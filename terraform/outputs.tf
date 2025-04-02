output "s3_bucket_name" {
  value = aws_s3_bucket.pipeline_bucket.bucket
}

output "codepipeline_name" {
  value = aws_codepipeline.my_pipeline.name
}

