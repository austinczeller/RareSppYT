#Train CNN with OpenSoundscape
#other utilities and packages
import torch
import pandas as pd
from pathlib import Path
import numpy as np
import pandas as pd
import random 
from glob import glob
import sklearn

#set up plotting
from matplotlib import pyplot as plt
plt.rcParams['figure.figsize']=[15,5] #for large visuals
%config InlineBackend.figure_format = 'retina'

torch.manual_seed(0)
random.seed(0)
np.random.seed(0)

# Set the current directory to where the dataset is 
dataset_path = Path("./annotated_data/")

# Make a list of all of the selection table files
selection_files = glob(f"{dataset_path}/Annotation_Files/*.txt")

# Create a list of audio files, one corresponding to each Raven file
# (Audio files have the same names as selection files with a different extension)
audio_files = [f.replace('Annotation_Files','COPI_Recordings').replace('.Table.1.selections.txt','.wav') for f in selection_files]

from opensoundscape.annotations import BoxedAnnotations
# Create a dataframe of annotations
annotations = BoxedAnnotations.from_raven_files(
    selection_files,
    audio_files)


%%capture
# Parameters to use for label creation
clip_duration = 3
clip_overlap = 0
min_label_overlap = 0.25
species_of_interest = ["COPI"]

# Create dataframe of one-hot labels
clip_labels = annotations.one_hot_clip_labels(
    clip_duration = clip_duration, 
    clip_overlap = clip_overlap,
    min_label_overlap = min_label_overlap,
    class_subset = species_of_interest # You can comment this line out if you want to include all species.
)

# Select files as a test set
test_set = clip_labels

# All other files will be used as a training set
train_and_val_set = clip_labels.drop(test_set.index)

# Save .csv tables of the training and validation sets to keep a record of them
train_and_val_set.to_csv("./annotated_data/train_and_val_set.csv")
test_set.to_csv("./annotated_data/test_set.csv")

train_and_val_set = pd.read_csv('./annotated_data/train_and_val_set.csv',index_col=[0,1,2])
test_set = pd.read_csv('./annotated_data/test_set.csv',index_col=[0,1,2])


# Split our training data into training and validation sets
train_df, valid_df = sklearn.model_selection.train_test_split(train_and_val_set, test_size=0.1, random_state=0)

train_df.to_csv("./annotated_data/train_set.csv")
valid_df.to_csv("./annotated_data/valid_set.csv")

from opensoundscape.data_selection import resample

# upsample (repeat samples) so that all classes have 800 samples
balanced_train_df = resample(train_df,n_samples_per_class=800,random_state=0)

# Create a CNN object designed to recognize 3-second samples
from opensoundscape import CNN

# Use resnet34 architecture
architecture = 'resnet34'

# Can use this code to get your classes, if needed
class_list = list(train_df.columns)

model = CNN(
    architecture = architecture,
    classes = class_list,
    sample_duration = clip_duration #3s, selected above
)

checkpoint_folder = Path("model_training_checkpoints")
checkpoint_folder.mkdir(exist_ok=True)

%%capture --no-stdout --no-display
# comment the line above to show outputs from this cell

model.train(
    balanced_train_df, 
    valid_df, 
    epochs = 15, 
    batch_size = 64, 
    log_interval = 100, #log progress every 100 batches
    num_workers = 4, #4 parallelized cpu tasks for preprocessing
    save_interval = 10, #save checkpoint every 10 epochs
    save_path = checkpoint_folder #location to save checkpoints
)