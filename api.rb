ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler/setup'

Bundler.require :default, ENV['RACK_ENV']

module API
  class User < Grape::API
    format :json

    helpers do
      params :pagination do
        optional :page, type: Integer, default: 1
        optional :per_page, type: Integer, default: 10
      end

      params :sorting do |options|
        optional :order_by, type:Symbol, values:options[:order_by], default:options[:default_order_by]
        optional :order, type:Symbol, values:%i(asc desc), default:options[:default_order]
      end
    end

    namespace '/users' do
      params do
        use :pagination
        use :sorting, order_by:%i(first_name last_name email created_at), default_order_by: :created_at, default_order: :desc

        optional :first_name, type:String
        optional :last_name, type:String
        optional :email, type:String
      end

      get do
        {id: 1, first_name: 'FirstName', last_name:'LastName', email: 'test@mail.ru', created_at: Time.now, gender: 'male'}
      end
      get '/metadata' do
        {
          columns: [
            {id: "ID",              type: 'numeric'},
            {first_name: 'Имя',     type: 'string',   enableFiltering:true,  enableSorting:true},
            {last_name: 'Фамилия',  type: 'string',   enableFiltering:true,  enableSorting:true},
            {email: 'Email',        type: 'string',   enableFiltering:true,  enableSorting:true},
            {created_at: Time.now,  type: 'datetime', enableSorting:true},
            {gender: 'Пол', type: 'string', visible:false}
          ]
        }
      end
    end
  end
end
