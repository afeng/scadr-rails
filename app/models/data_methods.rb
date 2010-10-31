module DataMethods
  def find_user(username)
    User.find_by_username(username)
  end

  def my_thoughts(username, count)
    Thought.find_all_by_owner(username, :limit => count)
  end

  def users_followed_by(username)
    Subscription.find_all_by_owner(username).collect { |sub| 
      self.find_user sub.target
      }
  end

  def users_following(username)
    Subscription.find_all_by_target(username).collect { |sub|
      self.find_user sub.owner
      }
  end
  
  # TODO: Massive optimize, although might be OK since only PIQL version really matters
  def thoughtstream(username, count)
    thoughtstream = []
    self.users_followed_by(username).each do |user|
      thoughtstream.concat self.my_thoughts(user.username,count)
    end
    thoughtstream.sort{ |t1,t2| t1.timestamp <=> t2.timestamp }[0,count]
  end

  def thoughts_by_hash_tag(tag, count)
    HashTag.find_all_by_tag(tag, :limit => count).collect { |ht|
      ht.get_thought
      }
  end
end