module RegionsHelper
  def unassociated_zones?
    Zone.where(region: nil).count > 0
  end
end
