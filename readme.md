# Leveraging autocatalytic reactions for chemical-domain image classification

MATLAB code for training and simulating the chemical-based image classification network detailed in our paper:

"Leveraging autocatalytic reactions for chemical-domain image classification" by Christopher E. Arcadia, Amanda Dombroski, Kady Oakley, Shui Ling Chen, Hokchhay Tann, Christopher Rose, Eunsuk Kim, Sherief Reda, Brenda M. Rubenstein, and Jacob K. Rosenstein. *Under Review 2020*.


## Requirements
To run this code, the following are required:
* [MATLAB](https://www.mathworks.com/products/matlab.html) (tested and developed on [R2020b](https://www.mathworks.com/products/new_products/latest_features.html))

* [CalTech 101 Silhouettes](https://people.cs.umass.edu/~marlin/data.shtml#:~:text=Description%3A%20This%20is%20a%20new,primary%20object%20in%20the%20scene.&text=The%20outline%20is%20rendered%20as,polygon%20on%20a%20white%20background) Data Set (download the [16x16 version](https://people.cs.umass.edu/~marlin/data/caltech101_silhouettes_16.mat))

  


## Usage

1. Download the CalTech 101 data set 

2. update the field `database_path` in the `configure_options.m` file with the database location.

3. Review and optionally edit the other program settings in the `configure_options.m` file.

4. Run the script `main.m` in MATLAB to train and simulate the network.

Also included is a script to analyze the images in the provided dataset (`analyze_dataset.m`) as well as a script to run multiple classification tests (`test_multiple_classifiers.m`).


## Cite

Please cite our paper if you use this code in your own work:

```
@article{arcadia2020submitted,
  title={Leveraging autocatalytic reactions for chemical-domain image classification},
  author={Arcadia et al.},
  year={2020}
}
```

