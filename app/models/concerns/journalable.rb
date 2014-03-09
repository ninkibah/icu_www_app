module Journalable
  extend ActiveSupport::Concern

  included do
    has_many :journal_entries, as: :journalable
    jtype = self.to_s
    JournalEntry.class_eval do
      # Note: needs class that includes Journalable to be loaded (see config/initialize/load_all_models.rb).
      scope jtype.tableize.to_sym, -> { where(journalable_type: jtype) }
    end
  end

  def journal(action, by, ip)
    action = action.to_s.downcase
    by = by.signature if by.respond_to?(:signature)
    if action == "create" || action == "destroy"
      journal_entries.create!(action: action, by: by, ip: ip)
    else
      journalable_columns = self.class.journalable_columns || self.class.superclass.journalable_columns
      previous_changes.each do |column, changes|
        if journalable_columns.include?(column)
          from, to = Util::Diff.new(*changes).difference
          journal_entries.create!(action: action, column: column, from: from, to: to, by: by, ip: ip)
        end
      end
    end
  end

  private

  module ClassMethods
    attr_reader :journalable_columns, :journalable_path

    def journalize(columns, path)
      @journalable_columns = Set.new(Array(columns).map(&:to_s))
      @journalable_path = path
    end
  end
end
