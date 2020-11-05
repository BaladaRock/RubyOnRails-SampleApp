class ApplicationController < ActionController::Base
    def hello
        render plain: "Hi! Are you staying safe?"
    end    
end
