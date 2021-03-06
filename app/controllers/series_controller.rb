class SeriesController < ApplicationController
  authorize_resource

  def index
    @series = Series.search(params, series_index_path, current_user)
    flash.now[:warning] = t("no_matches") if @series.count == 0
    save_last_search(@series, :series)
  end

  def show
    @series = Series.include_articles.find(params[:id])
    @prev_next = Util::PrevNext.new(session, Series, params[:id])
    @entries = @series.journal_search if can?(:create, Series)
  end
end
