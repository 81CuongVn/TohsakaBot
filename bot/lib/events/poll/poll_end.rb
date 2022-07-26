# frozen_string_literal: true

module TohsakaBot
  module Events
    module PollEnd
      extend Discordrb::EventContainer

      BOT.button(custom_id: /^poll\d+:end$/) do |event|
        next if event.user.bot_account

        user_id = event.user.id
        poll_author_id = event.custom_id.split(":", 2).first
        poll_author_id.slice!('poll')

        if user_id.to_i != poll_author_id.to_i
          event.respond(content: I18n.t("events.poll.vote.permission_error"), ephemeral: true)
          next
        end

        response = TohsakaBot.poll_cache.stop(event.message.id)

        # Remove buttons after the game has ended.
        Discordrb::API::Channel.edit_message(
          "Bot #{AUTH.bot_token}",
          event.channel.id,
          event.message.id,
          event.message.content,
          false,
          nil,
          nil
        )

        event.respond(content: "", ephemeral: false, embeds: response.embeds.map(&:to_hash))
      end
    end
  end
end

