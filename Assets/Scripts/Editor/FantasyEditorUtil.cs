using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.Linq;
using Newtonsoft.Json.Linq;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;
using UnityEditor.Animations;

namespace Fantasy.Editor
{
    public static class FantasyEditorUtil
    {
        class SparrowAnimCtx
        {
            public Sprite sprite = null;
            public float xOffset = 0;
            public float yOffset = 0;
        }

        [MenuItem("Fantasy/Sprites/Split Sparrow Texture")]
        [MenuItem("Assets/Fantasy/Sprites/Split Sparrow Texture")]
        public static void SplitSparrowSprite()
        {
            foreach (var obj in Selection.objects)
            {
                if (!(obj is Texture2D))
                    return;

                SplitSparrowSprite(obj as Texture2D);
            }
        }

        public static void SplitSparrowSprite(Texture2D texture, SpriteAlignment alignment = SpriteAlignment.Center)
        {
            string texturePath = AssetDatabase.GetAssetPath(texture);
            string atlasPath = texturePath.Replace(".png", ".xml");

            TextureImporter texImport = AssetImporter.GetAtPath(texturePath) as TextureImporter;
            TextAsset xmlText = AssetDatabase.LoadAssetAtPath<TextAsset>(atlasPath);

            List<SpriteMetaData> sprites = new List<SpriteMetaData>();
            List<Rect> sprRects = new List<Rect>();

            XmlDocument xml = new XmlDocument();

            xml.LoadXml(xmlText.text);

            XmlElement atlas = xml["TextureAtlas"];
            for (int i = 0; i < atlas.ChildNodes.Count; i++)
            {
                XmlNode node = atlas.ChildNodes[i];
                if (node.Name != "SubTexture")
                    continue;

                Rect sprRect = new Rect(int.Parse(node.Attributes["x"].Value), texture.height - int.Parse(node.Attributes["y"].Value),
                            int.Parse(node.Attributes["width"].Value), int.Parse(node.Attributes["height"].Value));
                sprRect.y -= sprRect.height;

                float xOffset = 0;
                float yOffset = 0;
                if (node.Attributes["frameX"] != null)
                {
                    float frameX = float.Parse(node.Attributes["frameX"].Value);
                    float frameY = float.Parse(node.Attributes["frameY"].Value);
                    float frameWidth = float.Parse(node.Attributes["frameWidth"].Value);
                    float frameHeight = float.Parse(node.Attributes["frameHeight"].Value);
                    float width = float.Parse(node.Attributes["width"].Value);
                    float height = float.Parse(node.Attributes["height"].Value);

                    xOffset = (frameWidth - width) / 2f + frameX;
                    yOffset = (frameHeight - height) / 2f + frameY;
                }

                if (!sprRects.Contains(sprRect))
                {
                    sprites.Add(new SpriteMetaData()
                    {
                        name = node.Attributes["name"].Value,
                        rect = sprRect,
                        alignment = (int)alignment,
                        pivot = new Vector2(0.5f + (xOffset / sprRect.width), 0.5f - (yOffset / sprRect.height)),
                        border = new Vector4(0f, 0f, 0f, 0f)
                    });
                    sprRects.Add(sprRect);
                }
            }

            texImport.mipmapEnabled = false;
            texImport.textureType = TextureImporterType.Sprite;
            texImport.textureShape = TextureImporterShape.Texture2D;
            texImport.spriteImportMode = SpriteImportMode.Multiple;
            texImport.spritesheet = sprites.ToArray();

            texImport.SaveAndReimport();
        }

        [MenuItem("Fantasy/Sprites/Split Sparrow Texture with Animations")]
        [MenuItem("Assets/Fantasy/Sprites/Split Sparrow Texture with Animations")]
        public static void SplitSparrowAnims()
        {
            foreach (var obj in Selection.objects)
            {
                if (!(obj is Texture2D))
                    return;

                string assetDir = Path.GetDirectoryName(AssetDatabase.GetAssetPath(obj));
                Dictionary<string, SparrowAnimCtx[]> animations = GetAnimsFromSparrow(obj as Texture2D);
                foreach (KeyValuePair<string, SparrowAnimCtx[]> pair in animations)
                {
                    AnimationClip anim = new AnimationClip()
                    {
                        name = pair.Key,
                        frameRate = 24f,
                        wrapMode = WrapMode.Clamp
                    };

                    /*AnimationCurve transformXCurve = new AnimationCurve();
                    EditorCurveBinding transformXBinding = new EditorCurveBinding()
                    {
                        type = typeof(Transform),
                        path = "",
                        propertyName = "localPosition.x"
                    };

                    AnimationCurve transformYCurve = new AnimationCurve();
                    EditorCurveBinding transformYBinding = new EditorCurveBinding()
                    {
                        type = typeof(Transform),
                        path = "",
                        propertyName = "localPosition.y"
                    };*/

                    List<ObjectReferenceKeyframe> spriteKeyFrames = new List<ObjectReferenceKeyframe>();
                    EditorCurveBinding spriteBinding = new EditorCurveBinding()
                    {
                        type = typeof(SpriteRenderer),
                        path = "",
                        propertyName = "m_Sprite"
                    };

                    for (int i = 0; i < pair.Value.Length; i++)
                    {
                        if (i == 0 || (pair.Value[i].sprite != null && pair.Value[i].sprite != pair.Value[i - 1].sprite))
                            spriteKeyFrames.Add(new ObjectReferenceKeyframe() { time = i / anim.frameRate, value = pair.Value[i].sprite });
                        //transformXCurve.AddKey(new Keyframe() { time = i / anim.frameRate, value = pair.Value[i].xOffset });
                        //transformYCurve.AddKey(new Keyframe() { time = i / anim.frameRate, value = pair.Value[i].yOffset });
                    }

                    //AnimationUtility.SetEditorCurves(anim, new EditorCurveBinding[] { transformXBinding, transformYBinding }, new AnimationCurve[] { transformXCurve, transformYCurve });
                    AnimationUtility.SetObjectReferenceCurve(anim, spriteBinding, spriteKeyFrames.ToArray());

                    AssetDatabase.CreateAsset(anim, assetDir + $"\\{pair.Key}.anim");
                }
            }
        }

        [MenuItem("Fantasy/Sprites/Split Sparrow Texture with Animations (UI)")]
        [MenuItem("Assets/Fantasy/Sprites/Split Sparrow Texture with Animations (UI)")]
        public static void SplitSparrowAnimsUI()
        {
            foreach (var obj in Selection.objects)
            {
                if (!(obj is Texture2D))
                    return;

                string assetDir = Path.GetDirectoryName(AssetDatabase.GetAssetPath(obj));
                Dictionary<string, SparrowAnimCtx[]> animations = GetAnimsFromSparrow(obj as Texture2D);
                foreach (KeyValuePair<string, SparrowAnimCtx[]> pair in animations)
                {
                    AnimationClip anim = new AnimationClip()
                    {
                        name = pair.Key,
                        frameRate = 24f,
                        wrapMode = WrapMode.Loop,
                    };

                    List<ObjectReferenceKeyframe> spriteKeyFrames = new List<ObjectReferenceKeyframe>();
                    EditorCurveBinding spriteBinding = new EditorCurveBinding()
                    {
                        type = typeof(Image),
                        path = "",
                        propertyName = "m_Sprite"
                    };

                    for (int i = 0; i < pair.Value.Length; i++)
                    {
                        if (i == 0 || (pair.Value[i].sprite != null && pair.Value[i].sprite != pair.Value[i - 1].sprite))
                            spriteKeyFrames.Add(new ObjectReferenceKeyframe() { time = i / anim.frameRate, value = pair.Value[i].sprite });
                    }

                    AnimationUtility.SetObjectReferenceCurve(anim, spriteBinding, spriteKeyFrames.ToArray());

                    AssetDatabase.CreateAsset(anim, assetDir + $"\\{pair.Key}.anim");
                }
            }
        }

        static Dictionary<string, SparrowAnimCtx[]> GetAnimsFromSparrow(Texture2D texture)
        {
            string texturePath = AssetDatabase.GetAssetPath(texture);
            string textureName = Path.GetFileNameWithoutExtension(texturePath);
            string assetDir = Path.GetDirectoryName(texturePath);

            XmlDocument xml = new XmlDocument();
            xml.LoadXml(AssetDatabase.LoadAssetAtPath<TextAsset>(assetDir + $"\\{textureName}.xml").text);
            XmlElement atlas = xml["TextureAtlas"];

            TextureImporter texImport = AssetImporter.GetAtPath(texturePath) as TextureImporter;
            texImport.textureType = TextureImporterType.Sprite;
            texImport.textureShape = TextureImporterShape.Texture2D;
            texImport.spriteImportMode = SpriteImportMode.Multiple;

            List<string> animNames = new List<string>();
            for (int i = 0; i < atlas.ChildNodes.Count; i++)
            {
                XmlNode node = atlas.ChildNodes[i];
                if (node.Name != "SubTexture")
                    continue;

                string animName = node.Attributes["name"].Value;
                animName = animName.Substring(0, animName.Length - 4);
                if (!animNames.Contains(animName))
                    animNames.Add(animName);
            }

            Dictionary<string, SparrowAnimCtx[]> animations = new Dictionary<string, SparrowAnimCtx[]>();
            List<SpriteMetaData> sprites = new List<SpriteMetaData>();
            List<Rect> spriteRects = new List<Rect>();
            List<int[]> animationIndices = new List<int[]>();
            for (int i = 0; i < animNames.Count; i++)
            {
                XmlNode[] spriteNodes = atlas.Cast<XmlNode>().Where(x => x.Name == "SubTexture"
                    && x.Attributes["name"].Value.StartsWith(animNames[i])
                    && int.TryParse(x.Attributes["name"].Value.Substring(animNames[i].Length), out int o)).ToArray();

                int[] indices = new int[spriteNodes.Length];
                SparrowAnimCtx[] animCtx = new SparrowAnimCtx[indices.Length];
                for (int n = 0; n < spriteNodes.Length; n++)
                {
                    SparrowAnimCtx ctx = new SparrowAnimCtx();
                    XmlNode node = spriteNodes[n];

                    Rect sprRect = new Rect(int.Parse(node.Attributes["x"].Value), texture.height - int.Parse(node.Attributes["y"].Value),
                            int.Parse(node.Attributes["width"].Value), int.Parse(node.Attributes["height"].Value));
                    sprRect.y -= sprRect.height;

                    float xOffset = 0;
                    float yOffset = 0;
                    if (node.Attributes["frameX"] != null)
                    {
                        float frameX = float.Parse(node.Attributes["frameX"].Value);
                        float frameY = float.Parse(node.Attributes["frameY"].Value);
                        float frameWidth = float.Parse(node.Attributes["frameWidth"].Value);
                        float frameHeight = float.Parse(node.Attributes["frameHeight"].Value);
                        float width = float.Parse(node.Attributes["width"].Value);
                        float height = float.Parse(node.Attributes["height"].Value);

                        xOffset = ((frameWidth - width)/2f + frameX);
                        yOffset = (frameHeight - height + frameY);
                    }

                    if (!spriteRects.Contains(sprRect))
                    {
                        sprites.Add(new SpriteMetaData()
                        {
                            name = node.Attributes["name"].Value,
                            rect = sprRect,
                            alignment = (int)SpriteAlignment.Custom,
                            pivot = new Vector2(0.5f + (xOffset / sprRect.width), -yOffset / sprRect.height),
                            border = new Vector4(0f, 0f, 0f, 0f)
                        });
                        spriteRects.Add(sprRect);
                    }

                    indices[n] = spriteRects.IndexOf(sprRect);
                    animCtx[n] = ctx;
                }
                animationIndices.Add(indices);

                animations.Add(animNames[i], animCtx.ToArray());
            }

            texImport.spritesheet = sprites.ToArray();
            
            texImport.SaveAndReimport();

            Sprite[] spriteAssets = AssetDatabase.LoadAllAssetsAtPath(texturePath).OfType<Sprite>().ToArray();
            for (int i = 0; i < animNames.Count; i++)
            {
                int[] indicies = animationIndices[i];
                for (int f = 0; f < indicies.Length; f++)
                    animations[animNames[i]][f].sprite = spriteAssets.Where(x => x.rect == spriteRects[indicies[f]]).FirstOrDefault();
            }

            return animations;
        }

        [MenuItem("Fantasy/Sprites/Adjust Offset for Animation")]
        [MenuItem("Assets/Fantasy/Sprites/Adjust Offset for Animation")]
        public static void AdjustOffsets()
        {
            if (!(Selection.activeObject is Texture2D))
                return;

            TextureImporter texImport = AssetImporter.GetAtPath(AssetDatabase.GetAssetPath(Selection.activeObject)) as TextureImporter;
            List<SpriteMetaData> selectedSprites = new List<SpriteMetaData>();
            List<SpriteMetaData> otherSprites = new List<SpriteMetaData>();

            string animName = EditorInputDialog.Show("Adjust Offset for Animation", "Enter the full name of the animation you want to adjust.\nEnter \"*\" to change all animations.", "");

            if (string.IsNullOrEmpty(animName))
            {
                Debug.Log("Input is empty or blank!");
                return;
            }

            foreach (SpriteMetaData spr in texImport.spritesheet)
                if (animName == "*" || spr.name.Substring(0, spr.name.Length - 4) == animName)
                    selectedSprites.Add(spr);
                else
                    otherSprites.Add(spr);

            if (selectedSprites.Count < 1)
            {
                Debug.Log($"No animations found with the name \"{animName}\"!");
                return;
            }

            float offsetX = 0f;
            float offsetY = 0f;

            string offsetXPrompt = EditorInputDialog.Show("Adjust Offset for Animation", "Enter the x offset you want to adjust it by.", "0");
            bool xValid = false;

            while (!xValid)
            {
                if (float.TryParse(offsetXPrompt, out float o))
                {
                    xValid = true;
                    offsetX = o;
                }
                else
                {
                    if (offsetXPrompt == null) { xValid = true; return; }
                    offsetXPrompt = EditorInputDialog.Show("Adjust Offset for Animation", "Enter the x offset you want to adjust it by. (Not a valid float. Please try again.)", "0");
                }
            }

            string offsetYPrompt = EditorInputDialog.Show("Adjust Offset for Animation", "Enter the y offset you want to adjust it by.", "0");
            bool yValid = false;

            while (!yValid)
            {
                if (float.TryParse(offsetYPrompt, out float o))
                {
                    yValid = true;
                    offsetY = o;
                }
                else
                {
                    if (offsetYPrompt == null) { yValid = true; return; }
                    offsetYPrompt = EditorInputDialog.Show("Adjust Offset for Animation", "Enter the y offset you want to adjust it by. (Not a valid float. Please try again.)", "0");
                }
            }

            SpriteMetaData[] spriteCollection = new SpriteMetaData[selectedSprites.Count + otherSprites.Count];

            for (int i = 0; i < selectedSprites.Count; i++)
            {
                spriteCollection[i] = new SpriteMetaData()
                {
                    name = selectedSprites[i].name,
                    alignment = selectedSprites[i].alignment,
                    pivot = selectedSprites[i].pivot + new Vector2(offsetX / selectedSprites[i].rect.width, offsetY / selectedSprites[i].rect.height),
                    border = selectedSprites[i].border,
                    rect = selectedSprites[i].rect
                };
            }

            otherSprites.CopyTo(spriteCollection, selectedSprites.Count);

            texImport.spritesheet = spriteCollection;
            EditorUtility.SetDirty(texImport);
            texImport.SaveAndReimport();
        }
    }
}
