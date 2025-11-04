// For local testing, use: #import "../src/lib.typ": simple-doc, code-listing, callout
// For published package, use:
#import "@preview/wut-thesis:0.1.1": simple-doc, code-listing, callout

#show: simple-doc.with(
  doc-type: "project",
  title: "Machine Learning Image Classifier",
  author: "John Doe",
  course: "CS 229: Machine Learning",
  instructor: "Prof. Jane Smith",
  date: datetime.today(),
  lang: "en",
  show-toc: true,
  show-figures: true,
  draft: true, // Set to false for final version
)

= Introduction

This project implements a convolutional neural network (CNN) for image classification using the CIFAR-10 dataset. The goal is to achieve high accuracy while maintaining reasonable training time.

== Objectives

The main objectives of this project are:
- Implement a CNN architecture from scratch
- Train the model on CIFAR-10 dataset
- Achieve >85% test accuracy
- Compare performance with baseline models

#callout(type: "note")[
  All experiments were conducted on a machine with NVIDIA RTX 3080 GPU.
]

= Methodology

== Dataset

The CIFAR-10 dataset consists of 60,000 32x32 color images in 10 classes, with 6,000 images per class. We split the data as follows:
- Training: 50,000 images
- Validation: 5,000 images
- Test: 10,000 images

== Model Architecture

Our CNN architecture consists of:
1. Convolutional layers with ReLU activation
2. Max pooling layers for downsampling
3. Fully connected layers for classification
4. Dropout for regularization

The complete architecture is shown in @model-arch.

#code-listing(
  caption: [CNN Model Architecture],
  lang: "python",
)[```python
import torch.nn as nn

class CIFAR10CNN(nn.Module):
    def __init__(self):
        super(CIFAR10CNN, self).__init__()
        self.conv1 = nn.Conv2d(3, 32, 3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, 3, padding=1)
        self.conv3 = nn.Conv2d(64, 128, 3, padding=1)
        self.pool = nn.MaxPool2d(2, 2)
        self.fc1 = nn.Linear(128 * 4 * 4, 512)
        self.fc2 = nn.Linear(512, 10)
        self.dropout = nn.Dropout(0.5)
    
    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = self.pool(F.relu(self.conv3(x)))
        x = x.view(-1, 128 * 4 * 4)
        x = self.dropout(F.relu(self.fc1(x)))
        x = self.fc2(x)
        return x
```] <model-arch>

== Training Procedure

We trained the model using:
- Optimizer: Adam with learning rate 0.001
- Loss function: Cross-entropy
- Batch size: 128
- Epochs: 50
- Learning rate scheduler: Reduce on plateau

= Results

== Performance Metrics

Our model achieved the following results on the test set:

#figure(
  table(
    columns: 3,
    [*Metric*], [*Value*], [*Baseline*],
    [Accuracy], [87.3%], [75.2%],
    [Precision], [86.8%], [74.5%],
    [Recall], [87.1%], [75.0%],
    [F1-Score], [86.9%], [74.7%],
  ),
  caption: [Model performance comparison]
) <results-table>

As shown in @results-table, our model significantly outperforms the baseline.

#callout(type: "important", title: "Key Finding")[
  The dropout layer was crucial for preventing overfitting. Without it, test accuracy dropped to 72%.
]

== Analysis

The model performs well across most classes, with some confusion between similar categories (e.g., cats vs. dogs, trucks vs. automobiles).

  = Conclusion

This project successfully implemented a CNN for image classification, achieving our target accuracy of >85%. Future work could explore:
- Data augmentation techniques
- Transfer learning with pre-trained models
- Ensemble methods

#bibliography("references.bib", style: "ieee")
