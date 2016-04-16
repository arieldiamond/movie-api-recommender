class PeopleList
  def people_list(params)
    people = params['id'].split(',')
    people_to_send = []
    people.each do |person|
      people_to_send << Person.find_by(tmdb_id: person)
    end
    people_to_send
  end

end