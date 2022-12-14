using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.InputSystem;
using Seleplus.Scripts;
using Seleplus.Objects.Player;

namespace Seleplus.Objects.Weapons
{
    public class RangedWeapon : Weapon
    {
        public Animator animator;
        public SpriteRenderer spriteRenderer;
        public Transform gunBarrel;
        private MouseTracker mouseTracker;

        public Transform center;
        public float radius = 1f;

        public bool flipX;

        public float angle;
        public float angleDegrees;
        private void Start()
        {
            mouseTracker = FindObjectOfType<MouseTracker>();
            flipX = spriteRenderer.flipX;
        }

        protected override void Update()
        {
            base.Update();

            // I KNOW THIS IS BAD BUT IT WORKS FOR NOW, I WILL REWORK LATER ;-;
            Vector2 mouseCalc = 
                isPlayer ? new Vector2(mouseTracker.worldPosition.x - gunBarrel.position.x, mouseTracker.worldPosition.y - gunBarrel.position.y) 
                : new Vector2(FindObjectOfType<Player.Player>().transform.position.x - gunBarrel.position.x, FindObjectOfType<Player.Player>().transform.position.y - gunBarrel.position.y);

            angle = (Mathf.Atan2(mouseCalc.y, mouseCalc.x));
            angleDegrees = angle * (180f / Mathf.PI);
            transform.position = new Vector3(center.position.x + (radius * Mathf.Cos(angle)), center.position.y + (radius * Mathf.Sin(angle)), center.position.z);

            Quaternion rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, angleDegrees);
            bool reached90 = (rotation.eulerAngles.z > 90f && rotation.eulerAngles.z < 270f);
            spriteRenderer.flipX = (!flipX ? reached90 : !reached90);

            if (reached90)
                rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, angleDegrees - 180);

            transform.rotation = rotation;
        }

        public override void OnAttack(string action)
        {
            switch (action)
            {
                case "Attack":
                    {
                        Shoot();
                        break;
                    }
            }
        }

        public virtual void Shoot()
        {
            animator.Play("shoot", 0, 0f);
        }
    }
}
