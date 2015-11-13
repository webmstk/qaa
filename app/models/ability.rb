class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end


  def guest_abilities
    can :read, :all
  end


  def admin_abilities
    can :manage, :all
  end


  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]

    can :update, [Question, Answer], user: user

    can :destroy, [Answer, Comment, Question], user: user
    can :destroy, Attachment do |attachment|
      user == attachment.attachable.user
    end

    can :best, Answer do |answer|
      user == answer.question.user
    end

    can [:like, :dislike], Vote do |vote|
      user != vote.votable.user
    end

    can :subscribe, Question
    can :unsubscribe, Question

    can :me, User, id: user.id
    can :index, User, id: user.id
  end
end

# Define abilities for the passed in user here. For example:
#
#   user ||= User.new # guest user (not logged in)
#   if user.admin?
#     can :manage, :all
#   else
#     can :read, :all
#   end
#
# The first argument to `can` is the action you are giving the user
# permission to do.
# If you pass :manage it will apply to every action. Other common actions
# here are :read, :create, :update and :destroy.
#
# The second argument is the resource the user can perform the action on.
# If you pass :all it will apply to every resource. Otherwise pass a Ruby
# class of the resource.
#
# The third argument is an optional hash of conditions to further filter the
# objects.
# For example, here the user can only update published articles.
#
#   can :update, Article, :published => true
#
# See the wiki for details:
# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
