module GdprConsent
  def self.add_script(type, params={})
    @scripts ||= {}.with_indifferent_access
    @scripts[type] ||= []

    if params[:policies].present?
      params[:policies].each_pair do |cookie, policy|
        self.add_policy(cookie, policy)
      end
    end

    @scripts[type] << params
  end

  def self.add_policy(cookie, params={})
    @policies ||= {}.with_indifferent_access
    @policies[cookie] = params
  end

  def self.get_all_scripts
    @scripts || {}
  end

  def self.get_scripts(type)
    @scripts ? @scripts[type] : nil
  end

  def self.get_policies
    @policies || {}
  end

  def self.configure(&block)
    block.(self)
  end
end
