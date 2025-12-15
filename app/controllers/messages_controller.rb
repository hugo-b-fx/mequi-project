class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chat || current_user.create_chat!(is_ai_chat: true)

    content = params[:message][:content].to_s.strip
    return head :unprocessable_entity if content.blank?

    # Message user
    @chat.messages.create!(
      content: content,
      role: "user",
      user: current_user
    )

    # CONTEXTE COACHS
    coaches = Coach.includes(:user)

    coaches_context = coaches.map do |coach|
      <<~STR
        - Nom: #{coach.user.full_name}
          Spécialités: #{coach.specialities}
          Localisation: #{coach.location}
          Prix: #{coach.price_per_session} €
          Expérience: #{coach.years_experience} ans
      STR
    end.join("\n")

    system_prompt = <<~PROMPT
      Tu es MequiA 🐎✨, l’assistant IA expert équestre de M’equi.

      Tu tutoies.
      Tu poses des questions si besoin.
      Tu aides vraiment à choisir, tu ne listes pas bêtement.

      Règles :
      - Utilise UNIQUEMENT les coachs ci-dessous
      - N’invente jamais
      - Explique toujours pourquoi tu proposes un coach
      - Si aucun match parfait, propose les plus proches

      Coachs disponibles :
      #{coaches_context}
    PROMPT

    messages_for_llm = @chat.messages.order(:created_at).last(10)

    conversation = messages_for_llm.map do |m|
      role = m.role == "assistant" ? "Assistant" : "User"
      "#{role}: #{m.content}"
    end.join("\n")

    final_prompt = <<~FINAL
      #{system_prompt}

      #{conversation}
      Assistant:
    FINAL

    begin
      response = RubyLLM.chat.ask(final_prompt)
      ai_content = response.content.presence || "Hmm 🤔 peux-tu préciser ?"
    rescue => e
      Rails.logger.error "[IA ERROR] #{e.message}"
      ai_content = "Oups 😅 j’ai eu un souci technique."
    end

    @chat.messages.create!(
      content: ai_content,
      role: "assistant",
      user: current_user
    )

    @message = @chat.messages.last

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to coaches_path }
    end
  end
end
