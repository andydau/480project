class AttemptsController < ApplicationController
        before_filter :authenticate_user!
	def index
	    @attempts = Attempt.all
	end

        def show
            @attempt = Attempt.find(params[:id])
        end

        def new
        	@problem = Problem.find(params[:problem_id])
        	@attempt = Attempt.new()
        end

        def create
            a = Attempt.new(create_params)
            a.user_id = current_user.id
        	@problem = Problem.find(params[:problem_id])
        	a.problem_id = @problem.id
            if a.save
                flash[:notice] = "Attempt submitted successfully!"
                redirect_to problem_attempts_path(@problem.id)
            else
                flash[:warning] = "Attempt couldn't be submitted"
                redirect_to new_problem_attempt_path(@problem.id)
            end
        end

private
        def create_params
            params.require(:attempt).permit(:submission)
        end
            
end
