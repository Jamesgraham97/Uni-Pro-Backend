class KanbanController < ApplicationController
  before_action :authenticate_user!
  layout 'authenticated'
  def index
    @todo_assignments = Assignment.where(status: 'To Do')
    @in_progress_assignments = Assignment.where(status: 'In Progress')
    @done_assignments = Assignment.where(status: 'Done')
  end
end
