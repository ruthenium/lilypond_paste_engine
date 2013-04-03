ActiveAdmin.register Paste do
	menu :priority => 2

	filter :created_at,      :as => :date_range
	filter :mxml_is_present, :as => :boolean, :label => "Only with MXML?"
	#filter :aadmin_mxml_not_null, :label => "MXML", :as => :radio, :collection => [['YES', 1], ['NO', 0]]
	filter :hold,         :as => :check_boxes
	filter :processed,    :as => :check_boxes
	filter :proc_success, :as => :check_boxes, :label => 'Processed successfully?'

	controller do # Bug in active admin. See https://github.com/gregbell/active_admin/issues/279
		defaults :finder => :find_by_visible_id
	end


	config.sort_order = "id_asc"
	config.per_page = 25

	index :download_links => false do
		selectable_column
		
		column :id do |p|
			link_to p.id, admin_paste_path(p.visible_id)
			# bug in active admin. See https://github.com/gregbell/active_admin/issues/279
		end
		#default_actions

		column :visible_id do |p|
			link_to p.visible_id, paste_path(p.visible_id)
		end

		column :created_at
		column :updated_at
		column :hold,         :sortable => false
		column :processed,    :sortable => false
		column :proc_success, :sortable => false
		column :images_count do |p|
			p.images.count
		end
		column :expires_at
	end

	show do |paste|
		attributes_table do
			row :id do
				link_to paste.id, admin_paste_path(paste.visible_id) # Bug in active admin. See https://github.com/gregbell/active_admin/issues/279
			end

			row :visible_id do
				link_to paste.visible_id, paste_path(paste.visible_id)
			end

			row :created_at
			row :updated_at
			row :expires_at
			
			row :lilypond_text
			row :mxml
			row :pdf
			row :lilypond
			row :hold
			row :processed do
				proc = paste.processed?
				succ = paste.proc_success?
				if proc
					if succ
						status_tag('processed', :ok)
					else
						status_tag('error', :error)
					end
				else
					status_tag('pending', :warning)
				end
			end
			row :status
			row :images_count do
				paste.images.count
			end
			row :images do # needs link for deletion.
				paste.images.map do |i|
					image_tag(i.png.url)
				end
			end
		end
		active_admin_comments
	end
  
end
