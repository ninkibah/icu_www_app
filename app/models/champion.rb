class Champion < ActiveRecord::Base
  include Journalable
  include Normalizable
  include Pageable

  journalize %w[category notes winners year], "/champions/%d"

  CATEGORIES = %w[open women]
  INITIALS = "([A-Z]\\.)+"
  SURNAME = "(O'|Mac|Mc)?[A-Z][a-z]+"
  SURNAMES = "#{SURNAME}([- ]#{SURNAME}){0,2}"
  WINNERS = /\A#{INITIALS}#{SURNAMES}(, #{INITIALS}#{SURNAMES})*\z/

  scope :ordered, -> { order(year: :desc, category: :asc) }

  before_validation :normalize_attributes, :correct_winners

  validates :category, inclusion: { in: CATEGORIES }, uniqueness: { scope: :year, message: "one category per year" }
  validates :winners, format: { with: WINNERS }, length: { maximum: 256 }
  validates :notes, length: { maximum: 256 }, allow_nil: true
  validates :year, numericality: { integer_only: true, greater_than_or_equal_to: Global::MIN_YEAR, less_than_or_equal_to: Date.today.year }

  def self.search(params, path)
    matches = ordered
    matches = matches.where(category: params[:category]) if CATEGORIES.include?(params[:category])
    matches = matches.where("winners LIKE ?", "%#{params[:winners]}%") if params[:winners].present?
    matches = matches.where("year LIKE ?", "%#{params[:year]}%") if params[:year].present? && params[:year].match(/\A(18|19|20)/)
    paginate(matches, params, path)
  end

  private

  def normalize_attributes
    normalize_blanks(:notes)
  end

  def correct_winners
    if winners.present?
      winners.gsub!(/[`‘’]/, "'")
      winners.gsub!(/\.\s+/, ".")
      winners.gsub!(/\s*([-.'])\s*/, '\1')
      winners.gsub!(/\b([A-Z])\s+(?!\.)/, '\1.')
      winners.gsub!(/\b([A-Z]{2,}|[a-z]{2,})\b/) { $1.capitalize }
      winners.trim!
    end
  end
end
