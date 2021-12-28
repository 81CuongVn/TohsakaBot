# frozen_string_literal: true

module TohsakaBot
  module CommandLogic
    class SetBirthday
      def initialize(event, raw_date)
        @event = event
        date_parts = raw_date.split('/')&.map(&:to_i)
        @date = Time.new(
          date_parts[0].clamp(1900, Time.now.year),
          date_parts[1].clamp(1, 12),
          date_parts[2].clamp(1, 31),
          '00',
          '00',
          '01'
        )
      end

      def run
        return { content: I18n.t(:'commands.tool.user.set_birthday.error.invalid_date') } if @date.nil?

        user_id = TohsakaBot.command_event_user_id(@event)
        TohsakaBot.db.transaction do
          TohsakaBot.db[:users].where(id: TohsakaBot.get_user_id(user_id)).update(
            birthday: @date,
            last_congratulation: 0
          )
        end

        { content: I18n.t(:'commands.tool.user.set_birthday.response', date: @date) }
      end
    end
  end
end