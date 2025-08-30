# frozen_string_literal: true

class TerminalsRepresenter
  def initialize(terminals)
    @terminals = terminals
  end

  def as_json
    terminals.map do |terminal|
      {
        id: terminal.id,
        owner: terminal.taxpayer.tin,
        taxpayer: terminal.taxpayer.name,
        terminal_id: terminal.terminal_id,
        terminal_label: terminal.terminal_label,
        activation_date: terminal.formatted_activation_date,
        status: terminal.status,
        posted_on: terminal.formatted_created_at
      }
    end
  end

  private

  attr_reader :terminals
end
