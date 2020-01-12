module TohsakaBot
  module Commands
    Dir["#{File.dirname(__FILE__)}/commands/*/*.rb"].each { |file| require file }
    # All commands listed below are activated and in use.
    @commands = [Eval, Help, Ping, Information, RoleAdd, RoleDel, Summon,
                 ReminderAdd, Tester, NowPlaying, Alko, Alkolist, Chaos,
                 Coinflip, Reminders, ReminderDel, Reboot,
                 TriggerAdd, TriggerDel, Triggers, ExclusionUrl,
                 Doubles, Triples, Quads, Stars, Spoiler, EncodeMsg,
                 RegardsKELA, Quickie, GetSauce, Winner, Loser, EmojiList, Number, AskRin, AnswerAdd]

    def self.include!
      @commands.each do |event|
        TohsakaBot::BOT.include!(event)
      end
    end
  end
end
