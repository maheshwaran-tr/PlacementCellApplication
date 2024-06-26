import { User } from "../models/user_models/userModel.js";

export const getUserById = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await User.findById(id);
        
        return res.status(200).json(user);
      } catch (error) {
        return res.status(500).send({ message: error.message });
      }
};

export const updateFcmToken = async (req, res) => {
  try {
      const { id } = req.params;
      const { fcmToken } = req.body;

      if (!id ||!fcmToken) {
          return res.status(400).json({ message: 'Both userId and fcmToken are required.' });
      }

      const user = await User.findById(id);

      if (!user) {
          return res.status(404).json({ message: 'User not found.' });
      }

      user.fcmToken = fcmToken; // Update the fcmToken
      await user.save(); // Save the changes

      res.json({ message: 'FCM Token updated successfully.', user: user._doc }); // Send success response
  } catch (error) {
      console.error(error);
      res.status(500).send('Server error');
  }
};