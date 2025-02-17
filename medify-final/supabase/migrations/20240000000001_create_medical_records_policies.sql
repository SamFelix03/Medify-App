-- Enable Row Level Security
ALTER TABLE medical_records ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to insert their own records
CREATE POLICY "Users can insert their own records"
ON medical_records FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Create policy to allow users to view their own records
CREATE POLICY "Users can view their own records"
ON medical_records FOR SELECT
USING (auth.uid() = user_id);

-- Create policy to allow users to update their own records
CREATE POLICY "Users can update their own records"
ON medical_records FOR UPDATE
USING (auth.uid() = user_id);

-- Create policy to allow users to delete their own records
CREATE POLICY "Users can delete their own records"
ON medical_records FOR DELETE
USING (auth.uid() = user_id);

-- Create storage bucket policies if not exists
INSERT INTO storage.buckets (id, name)
VALUES ('medical-attachments', 'medical-attachments')
ON CONFLICT (id) DO NOTHING;

-- Enable RLS for storage
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to upload their own files
CREATE POLICY "Users can upload their own files"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'medical-attachments' 
  AND auth.role() = 'authenticated'
);

-- Create policy to allow users to view their own files
CREATE POLICY "Users can view their own files"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'medical-attachments' 
  AND auth.role() = 'authenticated'
);

-- Create policy to allow users to delete their own files
CREATE POLICY "Users can delete their own files"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'medical-attachments' 
  AND auth.role() = 'authenticated'
); 