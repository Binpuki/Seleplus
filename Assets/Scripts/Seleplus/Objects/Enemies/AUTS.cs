using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using Seleplus.Objects.Player;

namespace Seleplus.Objects.Enemies
{
    public class AUTS : MonoBehaviour
    {
        [Header("Movement")]
        public float speed = 2f;

        [Header("References")]
        [SerializeField] private Animator spriteAnimator;
        [SerializeField] private SpriteRenderer spriteRenderer;
        [SerializeField] private Rigidbody2D rb;
        [SerializeField] private LayerMask groundLayer;
        [SerializeField] private Transform gunBarrel;
        [SerializeField] private LayerMask playerLayer;

        public Player.Player player;

        private void Start()
        {
            player = FindObjectOfType<Player.Player>();
        }

        private void Update()
        {
            spriteRenderer.flipX = transform.position.x > player.transform.position.x;
            gunBarrel.localPosition = new Vector3(0.53f * (transform.position.x > player.transform.position.x ? -1 : 1), gunBarrel.localPosition.y);

            if (Physics2D.OverlapCircle(transform.position, 0.3f, playerLayer))
                FindObjectOfType<Player.Player>().Damage(0.3f);
        }

        private void FixedUpdate()
        {
            bool playerOnLeft = transform.position.x <= player.transform.position.x;
            bool playerOnRight = transform.position.x > player.transform.position.x;

            if (playerOnLeft || playerOnRight)
            {
                int horizMultiplier = playerOnRight ? -1 : 1;
                rb.velocity = new Vector3(speed * horizMultiplier, rb.velocity.y);
            }
            else
            {
                rb.velocity = new Vector3(0, rb.velocity.y);
            }
        }
    }
}
