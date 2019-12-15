module TohsakaBot
  module Commands
    module Coinflip
      extend Discordrb::Commands::CommandContainer

      # Ratelimit for users. 15 times in a span of 60 seconds (1s delay between each).
      # TODO: Maybe move these to a single file across all commands?
      bucket :cf, limit: 15, time_span: 60, delay: 1

      command(:coinflip,
              # TODO: Move all command aliases to a single file.
              aliases: %i[coin flip toss kolike kolikko heitähomovoltti flop kkoin],
              description: 'Flip a coin.',
              usage: 'flip <integer>',
              bucket: :cf,
              rate_limit_message: "Calm down! You are ratelimited for %time%s.",
              rescue: "Something went wrong!\n`%exception%`") do |event, n|

        # Let's try to keep the CPU intact while we're at it.
        if n.to_i > 100000
          event.<< 'Sorry but the limit is 100000.'
          break
        end

        user_id = event.message.author
        role_id = $settings['winner_role'].to_i

        # Probabilities for the coin toss (%).
        coin = { "Tails:"  => 49, "Heads:" => 49, "The coin landed on its edge:" => 2 }
        coin_toss = Pickup.new(coin)

        if n.to_i > 1
          coins = coin_toss.pick(n.to_i)
          c = coins.uniq.map { |x| [x, coins.count(x)] }.to_h
          event.<< c.keys[0].to_s + ' ' + c.values[0].to_s + ' ' + c.keys[1].to_s + ' ' + c.values[1].to_s + ' ' + c.keys[2].to_s + ' ' + c.values[2].to_s
        else
          picked = coin_toss.pick(1)

          # Coinmaster manipulation (don't ask)
          if event.author.id.to_i == 73091459573616640
            picked = 'The coin landed on its edge'
          end

          if picked.chomp(':') == 'The coin landed on its edge'
            Kernel.give_temporary_role(event, role_id, user_id)
          end

          event.respond(picked.chomp(':'))
        end
      end
    end
  end
end
