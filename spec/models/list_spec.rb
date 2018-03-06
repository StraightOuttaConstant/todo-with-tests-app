require 'rails_helper'

RSpec.describe List, type: :model do
  describe '#complete_all_tasks!' do
    it 'should mark all tasks from the list as complete' do 
      list = List.create(name: "Groceries")
      Task.create(complete: false, list_id: list.id, name: "Sour Cream")
      Task.create(complete: false, list_id: list.id, name: "Sour Milk")

      list.complete_all_tasks!

      list.tasks.each do |task|
        expect(task.complete).to eq(true)
      end
    end
  end

  describe '#snooze_all_tasks!' do
    it 'should snooze each task' do
      list = List.create(name: "Feed Ciaran")
      times = [
                {time: Time.now, name: "turnips"}, 
                {time: 1.hour.from_now, name: "pizza"}, 
                {time: 42.days.ago, name: "bananas"}
              ]

      times.each do |time_hash|
        Task.create(list_id: list.id, deadline: time_hash[:time], name: time_hash[:name])
      end

      list.snooze_all_tasks!

      list.tasks.each_with_index do |task, index|
        expect(task.deadline).to eq(times[index][:time] + 1.hour)
      end
    end
  end

  describe '#total_duration' do
    it "should return the sum of all tasks' durations" do
      list = List.create(name: "Time Trials")
      Task.create(list_id: list.id, duration: 5, name: "race track time")
      Task.create(list_id: list.id, duration: 15, name: "horse track time")
      Task.create(list_id: list.id, duration: 45, name: "mario kart track time")

      expect(list.total_duration).to eq(65)
    end
  end

  describe '#incomplete_tasks' do 
    it 'should return all incomplete tasks for this list' do
      list = List.create(name: "Handy Man Jobs")
      task_1 = Task.create(list_id: list.id, complete: false, name: "Paint Garage")
      task_2 = Task.create(list_id: list.id, complete: true, name: "Paint Kitchen")
      task_3 = Task.create(list_id: list.id, complete: true, name: "Paint Bedroom")
      task_4 = Task.create(list_id: list.id, complete: false, name: "Paint Mailbox")
      task_1.toggle_complete!
      task_1.toggle_complete!

      expect(list.incomplete_tasks).to match_array([task_1, task_4])

      expect(list.incomplete_tasks.length).to eq(2)
      
      list.incomplete_tasks.each do |task|
        expect(task.complete).to eq(false)
      end
    end
  end

  describe '#favorite_tasks' do 
    it 'should return all favorite tasks for this list' do
      list = List.create(name: "Handy Man Jobs")
      task_1 = Task.create(list_id: list.id, favorite: false, name: "Paint Garage")
      task_2 = Task.create(list_id: list.id, favorite: true, name: "Paint Kitchen")
      task_3 = Task.create(list_id: list.id, favorite: false, name: "Paint Bedroom")
      task_4 = Task.create(list_id: list.id, favorite: true, name: "Paint Mailbox")
      task_2.toggle_complete!
      task_2.toggle_complete!

      expect(list.favorite_tasks).to match_array([task_2, task_4])

      expect(list.favorite_tasks.length).to eq(2)
      
      list.favorite_tasks.each do |task|
        expect(task.favorite).to eq(true)
      end
    end
  end
end









