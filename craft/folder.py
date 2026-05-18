import os
import shutil
import random

# Paths to your current dataset
current_images_dir = "C:/Users/AsharibSiddiqui/OneDrive - Octdaily/Desktop/CRAFT/text_detection-20241122T202253Z-001/text_detection/images"
current_annotations_dir = "C:/Users/AsharibSiddiqui/OneDrive - Octdaily/Desktop/CRAFT/text_detection-20241122T202253Z-001/text_detection/annotations"

# New data root directory
data_root_dir = "data_root_dir"
os.makedirs(data_root_dir, exist_ok=True)

# Define the new structure
folders = {
    "ch4_training_images": [],
    "ch4_training_localization_transcription_gt": [],
    "ch4_test_images": [],
    "ch4_test_localization_transcription_gt": [],
}

# Get all image and annotation files
image_files = sorted(os.listdir(current_images_dir))
annotation_files = sorted(os.listdir(current_annotations_dir))

# Ensure both lists have matching filenames
if len(image_files) != len(annotation_files):
    raise ValueError("The number of images and annotations must match.")

# Shuffle the dataset to randomize
combined = list(zip(image_files, annotation_files))
random.shuffle(combined)

# Split into train and test sets (1:9 ratio)
split_idx = len(combined) // 10  # 10% for test
test_set = combined[:split_idx]
train_set = combined[split_idx:]

# Populate the folder structure
folders["ch4_test_images"] = [os.path.join(current_images_dir, img) for img, _ in test_set]
folders["ch4_test_localization_transcription_gt"] = [os.path.join(current_annotations_dir, ann) for _, ann in test_set]
folders["ch4_training_images"] = [os.path.join(current_images_dir, img) for img, _ in train_set]
folders["ch4_training_localization_transcription_gt"] = [os.path.join(current_annotations_dir, ann) for _, ann in train_set]

# Create directories and copy files
for folder, files in folders.items():
    target_dir = os.path.join(data_root_dir, folder)
    os.makedirs(target_dir, exist_ok=True)
    for file in files:
        # Copy the file to the target directory
        target_file = shutil.copy(file, target_dir)
        
        # Rename the file if it's in 'ch4_training_localization_transcription_gt'
        if folder == "ch4_training_localization_transcription_gt" or folder =="ch4_test_localization_transcription_gt":
            base_name = os.path.basename(target_file)  # Get the filename
            new_name = f"gt_{base_name.replace('.txt', '').zfill(11)}.txt"  # Add prefix and pad with zeros
            new_path = os.path.join(target_dir, new_name)
            os.rename(target_file, new_path)

print(f"Dataset split, organized, and renamed in '{data_root_dir}' directory.")
