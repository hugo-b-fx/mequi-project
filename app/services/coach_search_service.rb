class CoachSearchService
  def initialize(params = {})
    @query = params[:query].to_s.strip
    @location = params[:location].to_s.strip
    @speciality = params[:speciality].to_s.strip
    @level = params[:level].to_s.strip
    @price_min = params[:price_min].presence
    @price_max = params[:price_max].presence
    @experience_min = params[:experience_min].presence
  end

  def call
    coaches = Coach.includes(:user, :reviews, :coach_availabilities)

    coaches = apply_text_search(coaches)
    coaches = apply_location_filter(coaches)
    coaches = apply_speciality_filter(coaches)
    coaches = apply_level_filter(coaches)
    coaches = apply_price_filter(coaches)
    coaches = apply_experience_filter(coaches)

    coaches.order(created_at: :desc)
  end

  private

  def apply_text_search(coaches)
    return coaches if @query.blank?
    coaches.search_by_text(@query)
  end

  def apply_location_filter(coaches)
    return coaches if @location.blank?
    coaches.by_location(@location)
  end

  def apply_speciality_filter(coaches)
    return coaches if @speciality.blank?
    coaches.by_speciality(@speciality)
  end

  def apply_level_filter(coaches)
    return coaches if @level.blank?
    coaches.by_level(@level)
  end

  def apply_price_filter(coaches)
    return coaches if @price_min.blank? && @price_max.blank?
    coaches.by_price_range(@price_min, @price_max)
  end

  def apply_experience_filter(coaches)
    return coaches if @experience_min.blank?
    coaches.by_experience(@experience_min)
  end
end
