class AttemptsController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:index, :show, :new, :create]

  def index
    @problem = Problem.find(params[:problem_id])
    @attempts = Attempt.order(grade: :desc).where("problem_id = ?", @problem.id)
  end

  def show
    @attempt = Attempt.find(params[:id])
    authorize @attempt
  end

  def new
    @problem = Problem.find(params[:problem_id])
    @attempt = Attempt.new
  end

  def create
    byebug
    if (params[:attempt][:submission]==nil)
      params[:attempt][:submission] = "Attempt not completed"
    end
    a = Attempt.new()
    a.submission = params[:attempt][:submission]
    a.user_id = current_user.id
    a.grade = -1
    
    @problem = Problem.find(params[:problem_id])
    @minute = @problem.time_limit
    a.problem_id = @problem.id

    if a.save
      flash[:notice] = "Attempt submitted successfully!"
      redirect_to problem_attempts_path(@problem.id)
    else
      flash[:warning] = "Attempt couldn't be submitted"
      redirect_to new_problem_attempt_path(@problem.id)
    end
  end

  def edit
    @problem = Problem.find(params[:problem_id])
    @attempt = Attempt.find(params[:id])
    authorize @attempt
  end

  def update
    @attempt = Attempt.find(params[:id])
    authorize @attempt

    if @attempt.update(update_params)
      flash[:notice] = "The attempt was graded successfully."
      redirect_to problem_attempts_path(@attempt.problem_id)
    else
      flash[:warning] = "The attempt was not graded successfully"
      redirect_to problem_attempt_path(@attempt.problem_id, @attempt.id)
    end
  end

  def destroy
    attempt = Attempt.find(params[:id])
    authorize attempt
    attempt.destroy
    redirect_to problems_path, :notice => "Attempt successfully deleted."
  end

  private

  def create_params
    params.require(:attempt).permit(:submission)
  end

  def update_params
    params.require(:attempt).permit(:grade)
  end

end
