### README: Material Evaluation Code

**Material Evaluation Script**  
Author: Beau Noland

#### Overview
This script automates the analysis of stress-strain data from material testing, specifically for standard dog bone specimens. It identifies key material properties such as Young’s modulus, yield strength, and maximum tensile strength, while also generating relevant plots. 

---

### Input Requirements
1. **Input File**:  
   The script processes an `.xlsx` file containing material testing data. Example input structure:
   - **Column 2**: Extensometer data (mm)
   - **Column 3**: Force data (N)
   - **Column 4**: Global displacement (μm)  
   Update the variable name `HT0test2` to match your dataset.

2. **Parameters**:  
   Default parameters for standard dog bone specimens:
   - Cross-sectional area (`area`): 5 mm²
   - Gauge length (`length`): 30 mm  
   Modify these values as needed for non-standard specimens.

3. **Thresholds**:
   - `threshold1`: Force jump for initial cropping (default: 5 N)
   - `threshold2`: Global displacement stall detection (default: 0.0001)
   - `threshold3`: Stress threshold for Young’s modulus calculation (default: 20,000,000 Pa)

---

### Outputs
1. **Material Properties**:
   - **Young’s modulus (global displacement and extensometer)**
   - **Yield strength**
   - **Maximum tensile strength**

2. **Plots**:
   - Stress-Strain curve highlighting the elastic region
   - Stress-Strain curve for extensometer data up to the stall point

---

### How to Run
1. Place your `.xlsx` input file in the working directory.
2. Adjust the dataset variable name if it differs from the default (`HT0test2`).
3. Run the script in MATLAB.
4. View results in the MATLAB console and visualizations in generated plots.

---

### Troubleshooting
- **Filename Errors**: If the dataset is not found, change the variable name (`HT0test2`) on the corresponding line to match your file.
- **Empty Cropping Errors**: Ensure the input file contains valid data with a clear force increase, stalling point, and dramatic force drop.

---

### Purpose
This script simplifies the repetitive and time-consuming process of analyzing material test data, enabling efficient determination of critical material properties.
