class S3Wrapper
  
  def initialize
    s3 = AWS::S3.new(
      :access_key_id => 'YOUR_ACCESS_KEY_ID',
      :secret_access_key => 'YOUR_SECRET_ACCESS_KEY')
  end

  class << self
    
    def self.url_for(content_path,bucket_name,options={})
      bucket = AWS::S3::Bucket.new(bucket_name)
      s3object = AWS::S3::S3Object.new(bucket,content_path)
      s3object.url_for(:read,options).to_s
    end

    def self.read(content_path,bucket_name,options={})
      bucket = AWS::S3::Bucket.new(bucket_name)
      s3object = AWS::S3::S3Object.new(bucket,content_path)
      s3object.read(options)
    end

    def self.store(file_path,file,bucket_name,options={})
      AWS::S3::Bucket.new(bucket_name).objects[file_path].write(file,options)
    end

    def self.find(file,bucket)
      AWS::S3::Bucket.new(bucket).objects[file]
    end

    def self.delete(file,bucket)
      find(file,bucket).delete
    end

    def self.find_with_prefix(bucket,prefix)
      AWS::S3::Bucket.new(bucket).objects.with_prefix(prefix)
    end

  end
end
