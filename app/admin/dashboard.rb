ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        paste_num = 10
        panel "#{paste_num} recent Pastes" do
          table_for Paste.order('created_at desc').limit(paste_num) do |t|
            t.column :status do |p|
              if p.processed?
                if p.proc_success?
                  status_tag('OK', :ok)
                else
                  status_tag('ERROR', :error)
                end
              else
                status_tag('PENDING', :warning)
              end
            end

            t.column "visible id" do |p|
              link_to p.visible_id, paste_path(p.visible_id)
            end

            t.column :id do |p|
              link_to p.id, admin_paste_path(p.visible_id) # Bug in active admin. See https://github.com/gregbell/active_admin/issues/279
            end

            t.column :created_at

            t.column :expires_at
          end # table
        end #panel
      end # column

      column do
        panel "Background jobs" do # thanks to https://gist.github.com/webmat/1887148
          now = Time.now.getgm
          ul do
            li do
              jobs = Delayed::Job.where('failed_at is not null').count(:id)
              link_to "#{jobs} failing jobs", admin_jobs_path(q: {failed_at_is_not_null: true}), style: 'color: red'
            end
            li do
              jobs = Delayed::Job.where('run_at <= ?', now).count(:id)
              link_to "#{jobs} late jobs", admin_jobs_path(q: {run_at_lte: now.to_s(:db)}), style: 'color: hsl(40, 100%, 40%)'
            end
            li do
              jobs = Delayed::Job.where('run_at >= ?', now).count(:id)
              link_to "#{jobs} scheduled jobs", admin_jobs_path(q: {run_at_gte: now.to_s(:db)}), style: 'color: green'
            end #li
          end # ul
        end # panel
      end # column
    end # columns
  end # content
end
