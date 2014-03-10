class Fee < ActiveRecord::Base
  extend Util::Pagination
  include Journalable
  journalize %w[
    name amount start_date end_date sale_start sale_end
    discounted_amount discount_deadline year years
    age_ref_date min_age max_age min_rating max_rating url
  ], "/admin/fees/%d"

  before_validation :normalize_attributes

  validates :type, :name, :amount, presence: true
  validate :valid_dates, :valid_discount, :valid_age_limits, :valid_rating_limits, :valid_url

  scope :alphabetic, -> { order(name: :asc) }
  scope :old_to_new, -> { order(end_date: :desc) }
  scope :new_to_old, -> { order(start_date: :asc) }

  def self.search(params, path)
    today = Date.today.to_s
    matches = all
    matches = matches.where(type: params[:type]) if params[:type].present?
    case params[:sale]
    when "current" then matches = matches.alphabetic.where("(sale_start IS NULL OR sale_start <= ?) AND (sale_end IS NULL OR sale_end >= ?)", today, today)
    when "past"    then matches = matches.old_to_new.where("sale_end < ?", today)
    when "future"  then matches = matches.new_to_old.where("sale_start > ?", today)
    when "all"     then matches = matches.alphabetic
    end
    paginate(matches, params, path, per_page: 10)
  end

  def season
    Season.new(years)
  end

  def subtype
    self.class.to_s.split("::").last.downcase
  end

  def deletable?
    items.count == 0
  end

  def rolloverable?
    respond_to?(:rollover)
  end

  def cloneable?
    respond_to?(:copy)
  end

  def advance_1_year
    %w[start_date end_date sale_start sale_end discount_deadline age_ref_date].each do |date|
      send("#{date}=", send(date).years_since(1)) if send(date).present?
    end
    self.year = year + 1 if year.present?
    self.years = Season.new(self.years).next.to_s if years.present?
  end

  private

  def normalize_attributes
    %w[name years url].each do |atr|
      self.send("#{atr}=", nil) if self.send(atr).blank?
    end
    if url.present? && url.match(/\A[-\w]+(\.[-\w]+)*(:\d+)?\z/)
      self.url = "http://#{url}"
    end
  end

  def valid_season
    season = self.season
    errors.add(:years, season.error) if season.error
  end

  def valid_dates
    if start_date.present? && end_date.present?
      if start_date > end_date
        errors.add(:start_date, "can't start after it ends")
      elsif end_date.year > start_date.year + 1
        errors.add(:end_date, "must end in the same or next year it starts")
      end
    end
    if sale_start.present? && sale_end.present? && sale_start > sale_end
      errors.add(:sale_start, "can't start after it ends")
    end
    if discount_deadline.present? && discounted_amount.present?
      if sale_start.present? && discount_deadline <= sale_start
        errors.add(:discount_deadline, "should be after sale starts")
      end
      if sale_end.present? && discount_deadline >= sale_end
        errors.add(:discount_deadline, "should be before sale ends")
      end
    end
  end

  def valid_discount
    if discounted_amount.present? && discounted_amount > amount
      errors.add(:discounted_amount, "discounted amount should be less than or equal to normal cost")
    end
  end

  def valid_age_limits
    if min_age || max_age
      unless age_ref_date.present?
        %i[min_age max_age].each { |m| errors[m] << "Age reference date required" if self.send(m) }
      end
    end
    if min_age && max_age && min_age > max_age
      errors[:base] << "Age minimum is greater than maximum"
    end
  end

  def valid_rating_limits
    return unless min_rating && max_rating
    if min_rating > max_rating
      errors[:base] << "Rating minimum is greater than maximum"
    elsif min_rating + 100 > max_rating
      errors[:base] << "Rating limits are too close"
    end
  end

  def valid_url
    return if url.blank?
    uri = URI.parse(url)
    raise "invalid URL" unless uri.try(:scheme).try(:match, /\Ahttps?\z/) && uri.host.present? && uri.port.present?
    req = Net::HTTP.new(uri.host, uri.port)
    req.read_timeout = 10
    res = req.start { |http| http.head(uri.path.blank? ? "/" : uri.path) }
    raise "got bad response for this URL" unless res.kind_of?(Net::HTTPSuccess)
  rescue => e
    errors.add(:url, e.message)
  end
end
