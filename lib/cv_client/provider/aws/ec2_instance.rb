module CvClient
  module Provider
    module Aws
      class EC2Instance < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'instance'
        STATUSES = {'pending' => 'running', 'running' => 'running', 'shutting-down' => 'stopped', 'terminated' => 'terminated', 'stopping' => 'stopped', 'stopped' => 'stopped'}
        PATH = "/v01/computes.json"
        
        def fetch_data
          data = {:provider => PROVIDER}
          REGIONS.each do |region|
            data.merge!(:location => region)
            ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
            instances = ec2.describe_instances
            instances.each do |instance|
              @data << parse_data(instance).merge(data)
            end
          end
        rescue RightAws::AwsError => e
          p "CV_CLIENT ERROR: #{e}"
        end
        
        def parse_data(instance)
          platform = instance.has_key?(:platform) ? 'windows' : 'linux'
          resources = INSTANCE_TYPES[instance[:aws_instance_type]]
          resource_type = RESOURCE_TYPE
          if instance[:instance_lifecycle]
            instance[:tags][:instance_lifecycle] = "spot"
            resource_type = "spot_instance"
          end
          return {'credential_label' => @label,
                  'label' => instance[:tags] ? instance[:tags]['Name'] : '',
                  'compute_type' => resource_type,
                  'reference_id' => instance[:aws_instance_id], 
                  'platform' => platform,
                  'status' => STATUSES[instance[:aws_state]],
                  'hypervisor' => instance[:hypervisor],
                  'architecture' => instance[:architecture],
                  'launch_time' => instance[:aws_launch_time],
                  'tags' => parse_tags(instance[:tags].values.insert(0, instance[:aws_instance_type]))}.merge(resources)
        end

        def send
          connection.post({:data => @data, :auth_token => @auth_token}, PATH)
        end

      end
    end
  end
end