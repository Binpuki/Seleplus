using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using Seleplus.Objects.Player;

namespace Seleplus.Objects.Enemies
{
    public class Dargoon : MonoBehaviour
    {
        [Header("Movement")]
        public float increaseSpeed = 0.4f;
        public float decreaseSpeed = 0.05f;
        public float maxSpeed = 10f;
        public float jumpSpeed = 2.5f;

        [Header("References")]
        [SerializeField] private Animator spriteAnimator;
        [SerializeField] private SpriteRenderer spriteRenderer;
        [SerializeField] private Rigidbody2D rb;
        [SerializeField] private LayerMask groundLayer;
        [SerializeField] private LayerMask playerLayer;

        public Player.Player player;

        private void Start()
        {
            player = FindObjectOfType<Player.Player>();
        }

        private void Update()
        {
            spriteRenderer.flipX = transform.position.x > player.transform.position.x;

            if (Physics2D.OverlapCircle(transform.position, 1f, playerLayer))
                FindObjectOfType<Player.Player>().Damage(0.3f);
        }

        private void FixedUpdate()
        {
            bool playerOnLeft = transform.position.x <= player.transform.position.x;
            bool playerOnRight = transform.position.x > player.transform.position.x;

            if (playerOnLeft || playerOnRight)
            {
                int horizMultiplier = playerOnRight ? -1 : 1;
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
