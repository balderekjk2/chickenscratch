# shared/admin.py
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin, GroupAdmin
from django.contrib.auth.models import Group
from .models import User

# I see superusers... and elevated_groups... (Only if I am a superuser)
super_seer = 'super_seer'

# I am super privileged (in whichever permissions have been set on my user)
super_privileged = 'super_privileged'

# elevated_groups, only visible to most trusted admin
# to see these groups, one must be a superuser and a member of the super_seer group
elevated_groups = (super_seer, super_privileged)

class CustomUserAdmin(UserAdmin):
  # Define fields for all users, including superusers
  fieldsets = (
    ("Personal info", {"fields": ("email", "first_name", "last_name")}),
    ("Permissions", {"fields": ("is_active", "is_staff", "is_superuser", "groups", "user_permissions")}),
    ("Important dates", {"fields": ("last_login", "date_joined")}),
  )

  # Define which fields to show for non-superusers
  limited_fieldsets = (
    ("Personal info", {"fields": ("email", "first_name", "last_name")}),
  )

  def get_form(self, request, obj=None, **kwargs):
    form = super().get_form(request, obj, **kwargs)
    if 'groups' in form.base_fields:
      if request.user.is_superuser and request.user.groups.filter(name=super_seer).exists():
        pass
      else:
        super_groups = Group.objects.filter(name__in=elevated_groups)
        form.base_fields["groups"].queryset = Group.objects.exclude(id__in=super_groups.values_list("id", flat=True))
      return form

  def get_fieldsets(self, request, obj=None):
    if request.user.is_superuser or request.user.groups.filter(name=super_privileged).exists():
      return super().get_fieldsets(request, obj)
    return self.limited_fieldsets

  def get_list_filter(self, request):
    if request.user.is_superuser or request.user.groups.filter(name=super_privileged).exists():
      return super().get_list_display(request)
    return ()

  def get_list_display(self, request):
    if request.user.is_superuser or request.user.groups.filter(name=super_privileged).exists():
      return super().get_list_display(request)
    return ('username', 'email', 'first_name', 'last_name')

  def get_queryset(self, request):
    qs = super().get_queryset(request)
    if request.user.groups.filter(name=super_seer).exists():
      return qs
    return qs.filter(is_superuser=False)

class CustomGroupAdmin(GroupAdmin):
  def get_queryset(self, request):
    qs = super().get_queryset(request)
    if request.user.is_superuser and request.user.groups.filter(name=super_seer).exists():
      return qs
    else:
      return qs.exclude(name__in=elevated_groups)

admin.site.unregister(Group)
admin.site.register(User, CustomUserAdmin)
admin.site.register(Group, CustomGroupAdmin)
