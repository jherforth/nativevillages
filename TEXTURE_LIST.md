# Required Mood & Desire Textures

The mood system needs 13 texture files to be placed in the `textures/` directory.

## Texture Specifications

**Format:** PNG with alpha transparency
**Recommended Size:** 32x32 pixels (or 64x64 for higher quality)
**Location:** `/textures/` directory
**Style:** Simple, clear icons that are recognizable at small sizes

## Required Mood Textures (8 files)

1. **nativevillages_mood_happy.png**
   - Emotion: Very happy, joyful
   - Suggestion: Big smile, bright colors (yellow/gold)

2. **nativevillages_mood_content.png**
   - Emotion: Satisfied, peaceful
   - Suggestion: Gentle smile, soft green/blue tones

3. **nativevillages_mood_neutral.png**
   - Emotion: Neutral, no strong feelings
   - Suggestion: Straight face, grey/neutral colors

4. **nativevillages_mood_sad.png**
   - Emotion: Unhappy, down
   - Suggestion: Frown, blue tones, maybe a tear

5. **nativevillages_mood_angry.png**
   - Emotion: Mad, frustrated
   - Suggestion: Angry eyebrows, red colors, grumpy expression

6. **nativevillages_mood_hungry.png**
   - Emotion: Needs food desperately
   - Suggestion: Meat/food icon, or hungry face, orange/brown tones

7. **nativevillages_mood_lonely.png**
   - Emotion: Wants companionship
   - Suggestion: Sad face or broken heart, purple tones

8. **nativevillages_mood_scared.png**
   - Emotion: Frightened, fearful
   - Suggestion: Wide eyes, worried expression, pale colors

## Required Desire Textures (5 files)

9. **nativevillages_desire_food.png**
   - Need: Wants to be fed
   - Suggestion: Bread, apple, or generic food icon

10. **nativevillages_desire_trade.png**
    - Need: Wants to trade items
    - Suggestion: Coins, gold ingot, or money bag

11. **nativevillages_desire_companionship.png**
    - Need: Wants social interaction
    - Suggestion: Two people icons, heart, or handshake

12. **nativevillages_desire_safety.png**
    - Need: Wants protection from danger
    - Suggestion: Shield, house, or protective symbol

13. **nativevillages_desire_rest.png**
    - Need: Needs healing/rest
    - Suggestion: Bed, ZZZ sleep icon, or medical cross

## Design Tips

- Use **high contrast** so icons are visible against various backgrounds
- Add a **subtle dark outline** (1-2 pixels) around the main icon for better visibility
- Keep designs **simple and iconic** - they'll be displayed at ~32 pixels
- Consider adding a **slight glow effect** or semi-transparent circular background
- Use **bright, saturated colors** that match the emotion/need
- Test visibility against both light and dark backgrounds

## Quick Creation Methods

### Option 1: Hand-drawn/Pixel Art
Use any image editor (GIMP, Krita, Photoshop, Aseprite) to create simple pixel art icons at 32x32.

### Option 2: Font Icons
Use emoji fonts or icon fonts (FontAwesome, etc.) rendered at 32-64px and saved as PNG.

### Option 3: AI Generation
Use AI art tools with prompts like:
- "simple pixel art happy face icon, 32x32, transparent background"
- "bread icon, game asset style, transparent background"

### Option 4: Free Icon Resources
- OpenGameArt.org
- Kenney.nl (free game assets)
- Game-icons.net (CC licensed icons)

## Testing

After adding textures, the icons will appear floating above NPC heads and will automatically switch based on the NPC's current mood and desires.
