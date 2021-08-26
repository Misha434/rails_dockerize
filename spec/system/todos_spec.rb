require 'rails_helper'

RSpec.describe Todo, type: :system do

  before do
    @todo = FactoryBot.build(:todo)
    visit '/'
  end
  describe '#index' do
    it 'has title Todos' do
      expect(page).to have_content('Todos')  
    end
    it 'has posted task' do
      @todo.save!
      visit current_path
      expect(page).to have_content('task-1')  
    end
  end
  describe '#show' do
    it 'has valid link to todos/1' do
      @todo.save!
      visit current_path
      click_on 'Show'
      expect(page).to have_content('Task:')  
      expect(page).to have_content('task-1')  
    end
  end
  describe '#new' do
    it 'can post task' do
      click_on 'New Todo'
      fill_in 'Task', with: @todo.task
      click_on 'Create Todo'
      expect(page).to have_content('task-1')  
    end
    it 'can post task with image' do
      click_on 'New Todo'
      fill_in 'Task', with: @todo.task
      attach_file 'todo_image', "#{Rails.root}/spec/fixtures/images/image_test.png"
      click_on 'Create Todo'
      expect(page).to have_content('task-1')  
      expect(page).to have_selector("img[src$='image_test.png']")
    end
    it 'can post task with image(JS ver.)', js: true do
      click_on 'New Todo'
      fill_in 'Task', with: @todo.task
      attach_file 'todo_image', "#{Rails.root}/spec/fixtures/images/image_test.png"
      click_on 'Create Todo'
      expect(page).to have_content 'task-'
      expect(page).to have_selector("img[src$='image_test.png']")
    end
  end
end