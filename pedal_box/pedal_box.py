from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt
base_dir = Path(__file__).parent
# Basic geometry parameters
# ==================================================
r_pedal = 220.0            # Pedal force point radius [mm]
r_sensor = 165.71          # Sensor mounting radius [mm]

pedal_i_angle_deg = -15.0  # Initial pedal force angle [deg]
sensor_i_angle_deg = -9.53 # Initial sensor angle [deg]

pedal_axis = np.array([0.0, 0.0])       # Pedal rotation center
sensor_axis = np.array([100.0, 30.0])   # Sensor fixed point

pedal_push_theta_deg = 11.89             # Maximum pedal rotation [deg]
pedal_push_theta = np.deg2rad(pedal_push_theta_deg)

# Helper function: rotation in XY plane
# ==================================================
def rotate_z(point, theta):
    x, y = point
    return np.array([
        x * np.cos(theta) + y * np.sin(theta),
       -x * np.sin(theta) + y * np.cos(theta)
    ])

# Initial points (XY plane)
# ==================================================
pedal_force_point = np.array([
    r_pedal * np.sin(np.deg2rad(pedal_i_angle_deg)),
    r_pedal * np.cos(np.deg2rad(pedal_i_angle_deg))
])

pedal_sensor_point = np.array([
    r_sensor * np.sin(np.deg2rad(sensor_i_angle_deg)),
    r_sensor * np.cos(np.deg2rad(sensor_i_angle_deg))
])

# Simulation setup
# ==================================================
n_step = 101
theta = np.linspace(0.0, pedal_push_theta, n_step)
theta_deg = np.rad2deg(theta)

pedal_x = np.zeros(n_step)
pedal_y = np.zeros(n_step)
sensor_x = np.zeros(n_step)
sensor_y = np.zeros(n_step)
sensor_length = np.zeros(n_step)

# Main kinematic loop
# ==================================================
for i, t in enumerate(theta):
    p_force = rotate_z(pedal_force_point, t)
    p_sensor = rotate_z(pedal_sensor_point, t)

    pedal_x[i], pedal_y[i] = p_force
    sensor_x[i], sensor_y[i] = p_sensor

    sensor_length[i] = np.hypot(
        sensor_axis[0] - p_sensor[0],
        sensor_axis[1] - p_sensor[1]
    )

# Derived quantities
# ==================================================
delta_sensor_length = -np.diff(sensor_length)
pedal_x_disp = pedal_x - pedal_x[0]

# Plot 1: Mechanism movement
plt.figure()
plt.plot(sensor_x, sensor_y, label="Sensor Trajectory")
plt.plot(pedal_x, pedal_y, label="Pedal Force Point Trajectory")

plt.plot([sensor_x[0], sensor_axis[0]],
         [sensor_y[0], sensor_axis[1]],
         label="Sensor Initial Position")

plt.plot([sensor_x[-1], sensor_axis[0]],
         [sensor_y[-1], sensor_axis[1]],
         label="Sensor Final Position")

plt.plot([pedal_x[0], pedal_axis[0]],
         [pedal_y[0], pedal_axis[1]],
         label="Pedal Initial Position")

plt.plot([pedal_x[-1], pedal_axis[0]],
         [pedal_y[-1], pedal_axis[1]],
         label="Pedal Final Position")

plt.title("Mechanism Movement Diagram")
plt.axis("equal")
plt.grid(True)
plt.legend(loc="best")
fig1_path = base_dir / "01_mechanism_movement.png"
plt.savefig(fig1_path, dpi=300, bbox_inches="tight")
plt.show()

# Plot 2: Pedal angle vs sensor length
plt.figure()
plt.plot(theta_deg, sensor_length)
plt.xlabel("Pedal Angle [deg]")
plt.ylabel("Sensor Length [mm]")
plt.title("Pedal Angle vs Sensor Length")
plt.grid(True)
fig2_path = base_dir / "02_pedal_angle_vs_sensor_length.png"
plt.savefig(fig2_path, dpi=300, bbox_inches="tight")
plt.show()

# Plot 3: Pedal X displacement vs sensor length
plt.figure()
plt.plot(pedal_x_disp, sensor_length)
plt.xlabel("Pedal Force X Displacement [mm]")
plt.ylabel("Sensor Length [mm]")
plt.title("Pedal X Displacement vs Sensor Length")
plt.grid(True)

fig3_path = base_dir / "03_pedal_x_vs_sensor_length.png"
plt.savefig(fig3_path, dpi=300, bbox_inches="tight")
plt.show()

# Plot 4: Pedal angle vs sensor length change
plt.figure()
plt.plot(theta_deg[1:], delta_sensor_length)
plt.xlabel("Pedal Angle [deg]")
plt.ylabel("Sensor Length Change [mm]")
plt.title("Pedal Angle vs Sensor Length Change")
plt.grid(True)
fig4_path = base_dir / "04_pedal_angle_vs_sensor_delta.png"
plt.savefig(fig4_path, dpi=300, bbox_inches="tight")
plt.show()

# Plot 5: Pedal X displacement vs sensor length change
plt.figure()
plt.plot(pedal_x_disp[1:], delta_sensor_length)
plt.xlabel("Pedal Force X Displacement [mm]")
plt.ylabel("Sensor Length Change [mm]")
plt.title("Pedal X Displacement vs Sensor Length Change")
plt.grid(True)

fig5_path = base_dir / "05_pedal_x_vs_sensor_delta.png"
plt.savefig(fig5_path, dpi=300, bbox_inches="tight")
plt.show()
