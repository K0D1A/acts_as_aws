module ActsAsAws
  module ActsAsAcmCertificate
    extend ActiveSupport::Concern
    include Base

    class_methods do
      def acts_as_acm_certificate(**options)
        arn_attr = options[:arn_attr] || :acm_certificate_arn
        certificate_attr = options[:certificate_attr] || :certificate
        private_key_attr = options[:private_key_attr] || :private_key
        ca_bundle_attr = options[:ca_bundle_attr] || :ca_bundle
        tags_method = options[:tags_method] || :acm_certificate_tags
        acts_as_aws(
          client_method: options[:client_method] || :acm_client,
          object_type: :acm_certificate,
          identifier_attr: arn_attr,
          creation_params_proc: ->(record) do
            tags = record.respond_to?(tags_method) ? record.send(tags_method) : {}
            {
              certificate: record.send(certificate_attr),
              private_key: record.send(private_key_attr),
              certificate_chain: record.send(ca_bundle_attr),
              tags: tags.map {|k, v| { key: k, value: v } },
            }
          end,
          creation_proc: ->(client, params) do
            resp = client.import_certificate(params)
            { arn_attr => resp.certificate_arn }
          end,
          deletion_proc: ->(client, arn) do
            client.delete_certificate(certificate_arn: arn)
          end,
          presence_proc: ->(client, arn) do
            resp = client.describe_certificate(certificate_arn: arn)
            resp.certificate.present?
          end,
          missing_error_class: 'Aws::ACM::Errors::ResourceNotFoundException',
        )
      end
    end
  end
end
