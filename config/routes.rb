Rails.application.routes.draw do


  scope module: 'api' do
    scope module: 'v1' do
      constraints lambda { |req| req.format == :json } do
        get     'anagrams/:word', to: 'anagrams#show'
        post    'words'         , to: 'words#create'
        delete  'words/:word'   , to: 'words#destroy'
        delete  'words'         , to: 'words#destroy'
        get     'stats'         , to: 'stats#stats'
      end

      get 'anagrams/check'      , to: 'anagrams#check'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
