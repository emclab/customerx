# encoding: utf-8
module Customerx
  module CustomersHelper
    
    def sales()
      sales = ''
      if has_action_right?('search', 'customerx_customers')
        sales = Authentify::UsersHelper.return_users('create', 'customerx_customers')
      elsif ghas_action_right?('search_zone', 'customerx_customers')
        sales = Authentify::UsersHelper.return_users('create', 'customerx_customers', session[:user_priviledge].user_zones)
      end
      sales
    end
    
    def return_quality_system
      Customerx::MiscDefinition.where(:for_which => 'customer_qs').where("active = ?", true).order("ranking_order")
    end
    
    def return_customer_status_category
      Customerx::MiscDefinition.where(:for_which => 'customer_status').where("active = ?", true).order("ranking_order")  
    end 
    
    def list_provinces
      ['北京市','天津市','上海市','重庆市','河北省','山西省','辽宁省','吉林省','黑龙江省',
        '江苏省','浙江省','安徽省','福建省','台湾省','江西省','山东省','河南省','湖北省',
        '湖南省','广东省','海南省','四川省','贵州省','云南省','陕西省','甘肃省','青海省','内蒙古自治区',
        '广西壮族自治区','西藏自治区','宁夏回族自治区','新疆维吾尔自治区','香港特别行政区','澳门特别行政区']
    end   
  end
end
