class ApplicationController < ActionController::Base
    def hello
        render text: "Hi! Are you staying safe?"
    end    
end
