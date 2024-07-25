const Rating = require('../models/Rating');
const Restaurant = require('../models/Restaurants'); 
const Food = require('../models/Food');

module.exports = {
  addRating: async (req, res) => {
    const { userId, ratingType, product, rating } = req.body;

    if (!userId || !ratingType || !product || !rating) {
      return res.status(400).json({ status: false, message: 'All fields are required' });
    }

    try {
      const newRating = new Rating({
        userId,
        ratingType,
        product,
        rating,
      });

      await newRating.save();

      // Calculate average rating for the related product
      const aggregatedRatings = await Rating.aggregate([
        { $match: { ratingType, product } },
        { $group: { _id: '$product', averageRating: { $avg: '$rating' } } }
      ]);

      if (aggregatedRatings.length > 0) {
        const averageRating = aggregatedRatings[0].averageRating;

        if (ratingType === 'Restaurant') {
          await Restaurant.findByIdAndUpdate(product, { rating: averageRating }, { new: true });
        } else if (ratingType === 'Food') {
          await Food.findByIdAndUpdate(product, { rating: averageRating }, { new: true });
        }
      }

      res.status(200).json({ status: true, message: 'Rating updated successfully' });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  checkUserRating: async (req, res) => {
    const { ratingType, product } = req.query;
    const userId = req.user.id;

    if (!userId || !ratingType || !product) {
      return res.status(400).json({ status: false, message: 'All fields are required' });
    }

    try {
      const existingRating = await Rating.findOne({
        userId,
        product,
        ratingType,
      });

      if (existingRating) {
        res.status(200).json({ status: true, message: 'You have already rated this item' });
      } else {
        res.status(200).json({ status: false, message: 'User has not rated this item' });
      }
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
};
