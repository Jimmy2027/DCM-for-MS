"""
This is a script to collapse the 115-AAL regions into 7 superordinate regions.
"""
from scipy.io import loadmat, savemat
import pandas as pd
import os
import numpy as np

data_file = loadmat('Daten/HC/ROI_Subject001_Session001.mat')
data_example = data_file['data']
names = [n.tolist()[0] for n in data_file['names'][0]]
names.append('Subject')

# Define the 7 regions

DGMN = ['aal.{}'.format(reg) for reg in
        ['Caudate (L)', 'Caudate (R)', 'Putamen (R)', 'Putamen (L)', 'Pallidum (L)', 'Pallidum (R)', 'Thalamus (L)',
         'Thalamus (R)']]

Frontal = [('aal.{}'.format(reg)).replace('_', ' ') for reg in
           ['Frontal_Inf_Tri (R)', 'Frontal_Inf_Tri (L)', 'Frontal_Inf_Oper (R)', 'Frontal_Inf_Oper (L)',
            'Frontal_Mid_Orb (R)',
            'Frontal_Mid_Orb (L)', 'Frontal_Mid (R)', 'Frontal_Mid (L)', 'Frontal_Sup (R)', 'Frontal_Sup (L)',
            'Precentral (R)',
            'Precentral (L)', 'Frontal_Med_Orb (R)', 'Frontal_Med_Orb (L)', 'Supp_Motor_Area (R)',
            'Supp_Motor_Area (L)',
            'Rolandic_Oper (R)', 'Rolandic_Oper (L)', 'Rectus (R)', 'Rectus (L)', 'Frontal_Inf_Orb (R)',
            'Frontal_Inf_Orb (L)']]

Prefrontal = [('aal.{}'.format(reg)).replace('_', ' ').replace(' R', ' (R)').replace(' L', ' (L)') for reg in
              ['Frontal_Sup_Medial_R', 'Frontal_Sup_Medial_L', 'Frontal_Sup_Orb_R', 'Frontal_Sup_Orb_L']]

Temporal = [('aal.{}'.format(reg)).replace('_', ' ').replace(' R', ' (R)').replace(' L', ' (L)') for reg in
            ['Hippocampus_R', 'Hippocampus_L', 'Temporal_Inf_R', 'Temporal_Inf_L', 'Temporal_Pole_Mid_R',
             'Temporal_Pole_Mid_L', 'Temporal_Mid_R', 'Temporal_Mid_L', 'Temporal_Pole_Sup_R', 'Temporal_Pole_Sup_L',
             'Temporal_Sup_R', 'Temporal_Sup_L', 'Heschl_R', 'Heschl_L', 'Olfactory_R', 'Olfactory_L', 'Insula_R',
             'Insula_L', 'Amygdala_R', 'Amygdala_L', 'ParaHippocampal_R', 'ParaHippocampal_L']]

Parietal = [('aal.{}'.format(reg)).replace('_', ' ').replace(' R', ' (R)').replace(' L', ' (L)') for reg in
            ['Lingual_R', 'Lingual_L', 'Cuneus_R', 'Cuneus_L',
             'Precuneus_R', 'Precuneus_L', 'Angular_R', 'Angular_L', 'SupraMarginal_R', 'SupraMarginal_L',
             'Parietal_Inf_R', 'Parietal_Inf_L', 'Parietal_Sup_R', 'Parietal_Sup_L', 'Postcentral_R',
             'Postcentral_L', 'Fusiform_R', 'Fusiform_L']]
Parietal.append('aal.Paracentral Lobule (R)')
Parietal.append('aal.Paracentral Lobule (L)')

Occipital = [('aal.{}'.format(reg)).replace('_', ' ').replace(' R', ' (R)').replace(' L', ' (L)') for reg in
             ['Occipital_Inf_R', 'Occipital_Inf_L', 'Occipital_Mid_R', 'Occipital_Sup_R', 'Occipital_Mid_L',
              'Occipital_Sup_L',
              'Calcarine_R', 'Calcarine_L', 'Cingulum_Post_R', 'Cingulum_Post_L', 'Cingulum_Mid_R', 'Cingulum_Mid_L',
              'Cingulum_Ant_R',
              'Cingulum_Ant_L']]

Cerebrellum = [('aal.{}'.format(reg)).replace('_', ' ').replace(' R', ' (R)').replace(' L', ' (L)') for reg in
               ['Cerebelum_8_R', 'Cerebelum_8_L', 'Cerebelum_7b_R', 'Cerebelum_7b_L', 'Cerebelum_6_R', 'Cerebelum_6_L',
                'Cerebelum_4_5_R',
                'Cerebelum_4_5_L', 'Cerebelum_3_R', 'Cerebelum_3_L', 'Cerebelum_Crus2_R', 'Cerebelum_Crus2_L',
                'Cerebelum_Crus1_R', 'Cerebelum_Crus1_L', 'Vermis_10', 'Vermis_9', 'Vermis_8', 'Vermis_7', 'Vermis_6',
                'Vermis_4_5', 'Vermis_3', 'Vermis_1_2', 'Cerebelum_10_R', 'Cerebelum_10_L', 'Cerebelum_9_R',
                'Cerebelum_9_L']]

Regions = [DGMN, Frontal, Prefrontal, Temporal, Parietal, Occipital, Cerebrellum]
Regions_names = ['DGMN', 'Frontal', 'Prefrontal', 'Temporal', 'Parietal', 'Occipital', 'Cerebrellum']

# number of subregions for each superordinate region
lenghts = [8, 22, 4, 22, 20, 14, 26]

# verify that each region has the number of sub-regions it should have. This limits the probability of a copy-paste error.
for i, region in enumerate(Regions):
    assert len(list(dict.fromkeys(region))) == lenghts[i], '{} should be of length {} but has length {}'.format(
        Regions_names[i], lenghts[i],
        len(region))
    for sub_region in region:
        assert sub_region in names, '{} not a AAL region'.format(sub_region)

dir = 'Daten/MS-new'
for folder in [f for f in os.listdir(dir) if not f.startswith('.')]:
    for file in os.listdir(os.path.join(dir, folder)):
        # iterate over all the MS files and group the 115 regions into 7 regions
        save_dir = os.path.join('Data_preprocessed', 'MS', folder)
        df = pd.DataFrame()
        path = os.path.join(dir, folder, file)
        mat_file = loadmat(path)
        names = [n.tolist()[0] for n in data_file['names'][0]]
        data = [n for n in mat_file['data'][0]]
        struct = {}
        for key, value in zip(names, data):
            if value.shape[1] > 1:
                # some regions have more than one value so the mean over those has to be taken
                value = value.mean(1)
            struct[key] = np.squeeze(value)
        # create temporary dataframe with all 115 regions and all 200 values for each region
        df_temp = pd.DataFrame(struct, index=[i for i in range(len(struct[key]))])
        # create new dataframe with the 7 superordinate regions
        for region, region_name in zip(Regions, Regions_names):
            df[region_name] = df_temp[region].values.mean(1)
        if not os.path.exists(save_dir):
            os.makedirs(save_dir)
        # create mat file for further use in matlab
        new_mat_file = mat_file
        new_mat_file['data'] = df.values
        new_mat_file['names'] = df.columns.to_list()
        split = file.split('_')
        if len(split) > 3:
            file = split[:3]
            file = '_'.join(file) + '.mat'
        savemat(os.path.join(save_dir, file), new_mat_file)
        # save csv file for easy visualisation
        df.to_csv(os.path.join(save_dir, file.split('.')[0] + '.csv'))

# here the same is done for the HC data
dirs = ['Daten/HCnew', 'Daten/HC']
for dir in dirs:
    for file in os.listdir(dir):
        subject = file.split('_')[1]
        save_dir = os.path.join('Data_preprocessed', 'HC', subject)
        df = pd.DataFrame()
        path = os.path.join(dir, file)
        mat_file = loadmat(path)
        names = [n.tolist()[0] for n in data_file['names'][0]]
        data = [n for n in mat_file['data'][0]]
        struct = {}
        for key, value in zip(names, data):
            if len(value) > 1:
                value = value.mean(1)
            struct[key] = np.squeeze(value)
        df_temp = pd.DataFrame(struct, index=[i for i in range(len(struct[key]))])
        for region, region_name in zip(Regions, Regions_names):
            df[region_name] = df_temp[region].values.mean(1)
        if not os.path.exists(save_dir):
            os.makedirs(save_dir)
        new_mat_file = mat_file
        new_mat_file['data'] = df.values
        new_mat_file['names'] = df.columns.to_list()
        if dir == 'Daten/HCnew':
            file = file.split('.')[0] + '_new.' + file.split('.')[1]
            savemat(os.path.join(save_dir, file), new_mat_file)
            df.to_csv(os.path.join(save_dir, file.split('.')[0] + '.csv'))
        else:
            savemat(os.path.join(save_dir, file), new_mat_file)
            df.to_csv(os.path.join(save_dir, file.split('.')[0] + '.csv'))
