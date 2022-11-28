using System.Collections;
using System.Collections.Generic;
using Seleplus.Data;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Seleplus.Objects.Player
{
    public class Player : InputHandler
    {
        bool isGrounded = false;

        [Header("Utilities")]

        [Header("Movement")]
        public float increaseSpeed = 0.4f;
        public float decreaseSpeed = 0.05f;
        public float maxSpeed = 10f;
        public float jumpSpeed = 5f;

        [Header("References")]
        [SerializeField] private Animator spriteAnimator;
        [SerializeField] private SpriteRenderer spriteRenderer;
        [SerializeField] private Rigidbody2D rb;
        [SerializeField] private LayerMask groundLayer;

        private Dictionary<string, bool> keysDown = new Dictionary<string, bool>();

        void Start()
        {
            ReloadKeybinds();
            inputsEnabled = true;

            // jump thing
            AddPressEvent("Space Pressed", null, (a) =>
            {
                if (isGrounded)
                {
                    spriteAnimator.Play("jump", 0);
                    spriteAnimator.speed = 1f;
                    rb.velocity = new Vector2(rb.velocity.x, jumpSpeed);
                }
            });
        }

        public void ReloadKeybinds()
        {
            string[] labels = { "Left", "Right", "Space" };

            for (int i = 0; i < SaveData.Data.Keybinds.Length; i++)
            {
                if (!keysDown.ContainsKey(labels[i]))
                    keysDown[labels[i]] = false;

                string bullShit = labels[i];

                AddPressEvent($"{labels[i]} Pressed", new string[] { SaveData.Data.Keybinds[i] }, (a) => { keysDown[bullShit] = true; });
                AddReleaseEvent($"{labels[i]} Released", new string[] { SaveData.Data.Keybinds[i] }, (a) => { keysDown[bullShit] = false; });
            }
        }

        void Update()
        {
            isGrounded = Physics2D.OverlapCircle(transform.position, 0.3f, groundLayer);

            if (keysDown["Left"] || keysDown["Right"])
            {
                if (isGrounded)
                {
                    spriteAnimator.Play("walk", 0);
                    spriteAnimator.speed = Mathf.Abs(rb.velocity.x) / maxSpeed;
                }
                else
                {
                    spriteAnimator.speed = 1f;
                }

                spriteRenderer.flipX = keysDown["Right"];
            }

            if (rb.velocity.x == 0f && isGrounded)
            {
                spriteAnimator.Play("idle", 0);
                spriteAnimator.speed = 1f;
            }


        }

        void FixedUpdate()
        {
            if (keysDown["Left"] || keysDown["Right"])
            {
                int horizMultiplier = keysDown["Left"] ? -1 : 1;
                float dSpeed = increaseSpeed * horizMultiplier;

                if (rb.velocity.x + dSpeed >= -maxSpeed && rb.velocity.x + dSpeed <= maxSpeed)
                    rb.velocity = new Vector3(rb.velocity.x + dSpeed, rb.velocity.y);
                else
                    rb.velocity = new Vector3(maxSpeed * horizMultiplier, rb.velocity.y);
            }
            else
            {
                bool goingBackwards = rb.velocity.x < 0f;
                int horizMultiplier = goingBackwards ? 1 : -1;
                float dSpeed = decreaseSpeed * horizMultiplier;

                if ((rb.velocity.x + dSpeed < 0f && goingBackwards) || (rb.velocity.x + dSpeed > 0f && !goingBackwards))
                    rb.velocity = new Vector3(rb.velocity.x + dSpeed, rb.velocity.y);
                else
                    rb.velocity = new Vector3(0f, rb.velocity.y);
            }
        }
    }
}
