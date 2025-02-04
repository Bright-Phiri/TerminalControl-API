# frozen_string_literal: true

class API::V1::TerminalsController < ApplicationController
  def index
    terminals = Terminal.all
    render json: terminals
  end
end
