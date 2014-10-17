#     EPSILIM - Suivi Financier
#     Copyright (C) 2014  Arnaud GARCIA - GCS EPSILIM
#
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.

module HtmlHelper
  # ----------------------------------------------------------
  #                        A C T I O N S
  # ----------------------------------------------------------

  def link_button(path, default_options={}, options={}, btn_class_name)
    if options[:roles]
      ok = current_user.has_role?(options[:roles])
      # vérification d'une restriction identité sur un rôle
      if ok && options[:restriction]
        role_method_restriction="is_#{options[:restriction][:role]}?"
        if current_user.send(role_method_restriction)
          ok=false unless current_user.id==options[:restriction][:id]
        end
      end
      default_options = {disabled: "disabled"}.reverse_merge(default_options) unless ok
    end
    if (options[:genre] && options[:genre] == :feminin)
      btn_class_name ="f_"+btn_class_name
    end
    options=options.reverse_merge(default_options)
    link_to t('.#{btn_class_name}', :default => t("helpers.links.#{btn_class_name}")), path, options
  end

  def back(path, options = {})
    link_button(path, {:class => 'btn btn-default'}, options, "back")
  end

  def edit(path,options={})
    options=options.reverse_merge({roles: [:direction]}) unless options[:roles]
    link_button(path, {:class => 'btn btn-warning'}, options, "edit")
  end

  def edit_small(path, options={})
    options=options.reverse_merge({roles: [:direction]}) unless options[:roles]
    link_button(path, {:class =>'btn btn-warning btn-small'}, options, "edit")
  end

  def new(path, options={})
    options=options.reverse_merge({roles: [:direction]}) unless options[:roles]
    link_button(path, {:class => 'btn btn-primary btn-lg'}, options, "new_html")
  end

  def cancel(path, options={})
    link_button(path, {:class => 'btn btn-default'}, options, "cancel")
  end

  def destroy (path, options = {})
    options=options.reverse_merge({roles: [:direction]}) unless options[:roles]
    default_options = {:method => :delete,
                       :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
                       :class => 'btn btn-danger btn-lg btn-block' }
    link_button(path, default_options, options, "destroy")
  end
  # --------------------- Horizontal FORM (hf) ---------------------
  def hf_field(form, method, *args, html_field_options)
    label = form.label(args[0], class: "col-sm-2 control-label")
    # args << {class: "form-control"}
    html_field_options = {class: "form-control"}.reverse_merge(html_field_options)
                            method_field = form.send(method, *args, html_field_options)
                            method_field_div = content_tag(:div, class: "col-sm-10") { method_field }
                            # --------------------- Horizontal FORM (hf) ---------------------
                            content_tag(:div, class: "form-group") do
                              label + method_field_div
                            end
                          end

                          def hf_number_field(form, field, html_field_options={})
                            hf_field(form, :number_field, field,html_field_options)
                          end

                          def hf_text_field(form, field, html_field_options={})
                            hf_field(form, :text_field, field, html_field_options)
                          end
                          def hf_text_area(form, field, html_field_options={})
                            hf_field(form, :text_area, field, html_field_options)
                          end
                          def hf_password_field(form, field, html_field_options={})
                            hf_field(form, :password_field, field, html_field_options)
                          end

                          def hf_date_select(form, field, html_field_options={})
                            hf_field(form, :date_select, field, html_field_options)
                          end

                          def hf_cancel_submit(form, path)

                            cancel_button = cancel path
                            submit_button = form.submit nil, class: 'btn btn-warning'
                            espace="&nbsp;&nbsp;&nbsp;&nbsp;".html_safe
                            method_field_div = content_tag(:div, cancel_button + espace +submit_button, class: "col-sm-offset-2 col-sm-10")

                            content_tag(:div, method_field_div, class: "form-group")
                          end

                          def hf_check_box(form, field, html_field_options={})
                            hf_field(form, :check_box, field, html_field_options)
                          end

                          def hf_select_with_collection(form, field, collection)
                            #f.select :type_charge_id, options_from_collection_for_select(@type_charges, 'id', 'nom', @charge.type_charge_id)
                            hf_field(form, :select, field, collection, {})
                          end
                          end
