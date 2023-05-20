class Search::UsersController < ApplicationController
  def first_letter
    @people = Person.where('name like ?', "#{params[:letter]}%").order(:name)
  end
  
  def name

  end
end
