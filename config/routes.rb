Rails.application.routes.draw do


  scope module: 'api' do
    scope module: 'v1' do
      constraints lambda { |req| req.format == :json } do
        get     'anagrams/:word', to: 'anagrams#show'
        post    'words'         , to: 'anagrams#create'
        delete  'words/:word'   , to: 'anagrams#destroy'
        delete  'words'         , to: 'anagrams#destroy'
        get     'stats'         , to: 'anagrams#stats'
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
