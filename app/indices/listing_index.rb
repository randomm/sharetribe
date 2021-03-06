ThinkingSphinx::Index.define :listing, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do

  # limit to open listings
  where "open = '1' AND (valid_until IS NULL OR valid_until > now())"
  
  # fields
  indexes title
  indexes description
  indexes category.translations.name, :as => :category
  indexes custom_field_values(:text_value), :as => :custom_text_fields
  
  # attributes
  has created_at, updated_at
  has category(:id), :as => :category_id
  has share_type(:id), :as => :share_type_id 
  has "privacy = 'public'", :as => :visible_to_everybody, :type => :boolean
  has communities(:id), :as => :community_ids
  has custom_field_values.selected_options.id, :as => :custom_field_options, :type => :integer, :multi => true
  
    
  set_property :enable_star => true
  
  set_property :field_weights => {
    :title       => 10,
    :category    => 8,
    :description => 3
  }

end
