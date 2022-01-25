module ActsAsAws
  class Engine < ::Rails::Engine
    config.after_initialize do
      ActiveSupport.on_load(:active_record) do
        include ActsAsAwsCredentials
        include ActsAsAwsClient
        include ActsAsAcmCertificate
        include ActsAsAwsLoadBalancer
      end
    end
  end
end
